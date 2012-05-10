class AddAttachmentToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :attachment_file_name, :string
    add_column :tickets, :attachment_content_type, :string
    add_column :tickets, :attachment_file_size, :integer
    add_column :tickets, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :tickets, :attachment_file_size
    remove_column :tickets, :attachment_content_type
    remove_column :tickets, :attachment_file_name
    remove_column :tickets, :attachment_updated_at
  end
end
