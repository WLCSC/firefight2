class MailMan < ActionMailer::Base
	include Resque::Mailer
  default :from => "noreply@wl.k12.in.us"
  
  def test to
	mail(:to => to, :subject => 'Firefight Mail Test')
  end
  
  def ticket_submitted user, ticket, comment
    @user = User.find(user)
	@ticket = Ticket.find(ticket)
	@comment = Comment.find(comment)
	mail(:to => @user.email, :subject => "Ticket ##{@ticket.id}")
  end

  def tech_submitted user, ticket, comment
	@user = User.find(user)
	@ticket = Ticket.find(ticket)
	@comment = Comment.find(comment)
	mail(:to => @user.email, :subject => "Ticket ##{@ticket.id}")
  end
  
  def ticket_updated ticket, user
	@ticket = Ticket.find(ticket)
	@user = User.find(user)
	mail(:to => @user.email, :subject => "Ticket ##{@ticket.id}")
  end

  def loan_submitted user, loan
    @user = User.find(user)
    @loan = Loan.find(loan)
    mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
  end

  def tech_loan user, loan
    @user = User.find(user)
    @loan = Loan.find(loan)
    mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
  end

  def loan_approved user, loan
    @user = User.find(user)
    @loan = Loan.find(loan)
    mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
  end

	def loan_denied user, loan
    @user = User.find(user)
    @loan = Loan.find(loan)
    mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
  end

  def loan_return user, loan
    @user = User.find(user)
    @loan = Loan.find(loan)
    mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
  end

	def loan_remind user, loan
		@loan = Loan.find(loan)
		@user = User.find(user)
		mail(:to => @user.email, :subject => "Tech Equipment Loan ##{@loan.id}")
	end

	def consumable_alert alert
		@alert = Alert.find(alert)
		@user = @alert.user
		@building = @alert.building
		mail(:to => @user.email, :subject => "Consumable Alert #{Time.now.strftime("%I:%M %p %m-%d-%Y")}")
	end


end
