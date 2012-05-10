class CreateLoans < ActiveRecord::Migration
  def self.up
    create_table :loans do |t|
      t.date :start_date
      t.date :end_date
      t.text :use
      t.boolean :approved
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :loans
  end
end
