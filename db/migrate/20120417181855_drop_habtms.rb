class DropHabtms < ActiveRecord::Migration
  def up
	  create_table :tags do |t|
		t.integer :user_id
		t.integer :ticket_id
	  end
	  execute('INSERT INTO tags (user_id, ticket_id) SELECT user_id, ticket_id FROM tickets_users')

	  drop_table :tickets_users

	  create_table :requests do |t|
		  t.integer :loan_id
		  t.integer :rtype_id
	  end
	  execute('INSERT INTO requests (loan_id, rtype_id) SELECT loan_id, rtype_id FROM loans_rtypes')

	  drop_table :loans_rtypes
  end

  def down
  end
end
