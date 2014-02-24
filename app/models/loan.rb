class Loan < ActiveRecord::Base
	belongs_to :user
	has_many :returns
    has_many :assets, :through => :returns
	has_many :requests
	has_many :rtypes, :through => :requests
	attr_accessor :start, :end
	before_create :fix_dates
	validates :start, :end, :presence => true, :on => :create

	def active
		ret = false
		self.returns.each do |r|
			ret = true unless r.returned
		end
		ret
	end

    def open
        approved ? active : false
    end

	def Loan.open 
		all.delete_if{|l| l.approved ? !l.active: false}
	end

	def statusify
		if self.approved 
			if self.active
				if self.end_date >= Date.today 
					"Active"
				else
					'<span style="color: #a60400; font-weight: bold;">Late</span>'.html_safe
				end
			else
				'<span style="color: #A65400;">Complete</span>'.html_safe
			end
		else
			if self.approved == nil
			'<span style="color: #FFBA00;">Waiting for approval</span>'.html_safe
			else
			'<span style="color: #aa3300;">Denied</span>'.html_safe
			end
		end
	end

	def badge
		if self.approved 
			if self.active
				if self.end_date >= Date.today 
					'<span class="badge badge-info">' + self.id.to_s + '</span>'
				else
					'<span class="badge badge-error">' + self.id.to_s + '</span>'
				end
			else
					'<span class="badge badge-success">' + self.id.to_s + '</span>'
			end
		else
			if self.approved == false
					'<span class="badge badge-inverse">' + self.id.to_s + '</span>'
			else
					'<span class="badge badge-warning">' + self.id.to_s + '</span>'
			end
		end
	end

	def fix_dates
		if self.start
			begin
			self.start.match /(\d+)\/(\d+)\/(\d+)/
			self.start_date = Date.civil($3.to_i, $1.to_i, $2.to_i)
			rescue
				self.errors.add :start_date, "is invalid"
			end
		else
			raise 'no start date'
		end

		if self.end
			begin
			self.end.match /(\d+)\/(\d+)\/(\d+)/
			self.end_date = Date.civil($3.to_i, $1.to_i, $2.to_i)
			rescue
				self.errors.add :end_date, "is invalid"
			end
		else
			raise 'no end date'
		end
		true
	end
end
