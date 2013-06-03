class CreateConsumables < ActiveRecord::Migration
  def change
    create_table :consumables do |t|
      t.string :name
      t.string :short
      t.decimal :cost, :precision => 6, :scale => 2

      t.timestamps
    end
  end
end
