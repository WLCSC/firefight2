task :deliver_reminders => :environment do
	loans = Set.new
	loans += Loan.where(:start_date => Date.today).where(:approved => true).all
	loans += Loan.where(:end_date => Date.today).where(:approved => true).all

	User.where(:administrator => true).each do |u|
		loans.each do |l|
			MailMan.loan_remind(u,l).deliver
		end
	end
end
