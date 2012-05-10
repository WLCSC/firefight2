class AddParentToTicketqueues < ActiveRecord::Migration
  def change
    add_column :ticketqueues, :parent_id, :integer

    add_column :ticketqueues, :parent_type, :string

  end
end
