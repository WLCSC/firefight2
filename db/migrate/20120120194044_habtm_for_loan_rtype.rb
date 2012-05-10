class HabtmForLoanRtype < ActiveRecord::Migration
  def self.up
	create_table :loans_rtypes, :id => false do |t|
		t.references :loan, :null => false
		t.references :rtype, :null => false
	end
  end

  def self.down
  end
end
