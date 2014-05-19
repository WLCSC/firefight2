class Ticket < ActiveRecord::Base
    has_many :tags
    has_many :users, :through => :tags
    belongs_to :asset
    belongs_to :room
    has_many :comments
    has_many :contexts
    belongs_to :ticketqueue
    belongs_to :submitter, :class_name => 'User'
    has_many :missions
    attr_accessor :comment, :due_at, :asset_tag, :photo
    after_create :set_comment
    after_create :fix_due
    before_save :find_asset

    has_many :photos, :as => :photographable
    accepts_nested_attributes_for :photos

    has_attached_file :attachment, :styles => {:preview => ["320x240>", :png], :small => ["640x480>", :png]}
    #validates_attachment_content_type :attachment, :content_type=>['image/jpeg', 'image/png', 'image/gif']	
    scope :low, where("`tickets`.status = 1")
    scope :routine, where("status = 2")
    scope :urgent, where("status = 3")
    scope :deferred, where("status = 99")
    scope :completed, where("status = 100")
    scope :incomplete, where("status != 100")

    def self.readable_by(user)
        if user.admin?
            self.where(true)
        else
            q1 = self.where(:ticketqueue_id => user.readable_queues.map{|q| q.id}).map{|t| t.id}
            q2 = self.where(:id => user.tickets.map{|t| t.id}).map{|t| t.id}
            Ticket.where(:id => (q1 + q2))
            #self.where(:ticketqueue_id => user.readable_queues.map{|q| q.id})#.merge(self.where(:id => (user.tickets.map{|t| t.id} )))
        end
    end

    def tagged_related_tickets recurse = true
        tx = []
        Comment.where("content RLIKE 'apps\\.wl\\.k12\\.in\\.us/firefight/tickets/0*" + self.id.to_s + "'").each do |c|
            unless c.ticket == self
                tx << c.ticket
                tx += c.ticket.tagged_related_tickets(false)
            end
        end

        if recurse
            self.comments.each do |comment|
                if comment.content.match(/apps\.wl\.k12\.in\.us\/firefight\/tickets\/([0-9]+)/)
                    unless Ticket.find($1) == self
                        tx << Ticket.find($1)
                        tx += Ticket.find($1).tagged_related_tickets
                    end
                end
            end
        end

        tx.uniq
    end


    attr_accessible :room_id, :asset_id, :ticketqueue_id, :status, :attachment, :submitter_id, :due, :comment, :due_at, :context_list, :asset_tag, :photo

    def statusify
        return 'Low' if status==1
        return 'Routine' if status==2
        return 'Urgent' if status==3
        return 'Deferred' if status==99
        return 'Completed' if status==100
        return 'Undefined'
    end

    def context_list
        self.contexts.all.map{|c| c.tag}.join(', ')
    end

    def assigned?
        return submitter if submitter.admin? 
        users.each do |user|
            if(user.admin?) then return user end
        end
        false
    end

    def room
        self.room_id ? Room.where(:id => self.room_id).first : asset.room
    end

    def late?
        if status != 100
            self.due ? self.due < Time.now : false
        else
            false
        end
    end

    def complete?
        self.status == 100
    end

    def set_comment
        if self.comment
            Comment.create!(:user_id => self.submitter.id, :content => self.comment, :ticket_id => self.id)
        end
        Tag.create!(:ticket_id => self.id, :user_id => self.submitter.id)
    end

    def fix_due
        if self.due_at != "" && self.due_at.is_a?(String)
            self.due_at.match /(\d+)\/(\d+)\/(\d+) (\d+):(\d+)/
                begin
                self.due = DateTime.civil($3.to_i, $1.to_i, $2.to_i, $4.to_i, $5.to_i)
                rescue
                    self.errors.add(:due_at, "is not a valid date.")
                end

        elsif self.due_at != ""
                    self.errors.add(:due_at, "is not a valid date.")
        end

    end

    def find_asset
        if self.asset_tag
            self.asset = Asset.where(:tag => self.asset_tag).first
        end
    end

    def lifetime
        comments.last.created_at - comments.first.created_at
    end
end
