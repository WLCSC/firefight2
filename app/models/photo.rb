class Photo < ActiveRecord::Base
	has_attached_file :image, :styles => {:preview => ["320x240>", :png], :small => ["640x480>", :png], :icon => ["48x48>", :png]}

	belongs_to :photographable, :polymorphic => :true
	belongs_to :user
end
