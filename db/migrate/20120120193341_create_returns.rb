class CreateReturns < ActiveRecord::Migration
  def self.up
    create_table :returns do |t|
      t.integer :loan_id
      t.integer :asset_id
      t.boolean :returned

      t.timestamps
    end
  end

  def self.down
    drop_table :returns
  end
end
