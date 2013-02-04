class AddLoanableToRtype < ActiveRecord::Migration
  def change
    add_column :rtypes, :loanable, :boolean

  end
end
