class MailMan < ActionMailer::Base
  default :from => "support@wl.k12.in.us"
  
  def test
	mail(:to => 'thompsonb@wl.k12.in.us', :subject => 'Firefight Mail Test')
  end
  
  def ticket_submitted user, ticket, comment
    @user = user
	@ticket = ticket
	@comment = comment
	mail(:to => user.email, :subject => "Ticket ##{ticket.id}")
  end

  def tech_submitted user, ticket, comment
	@user = user
	@ticket = ticket
	@comment = comment
	mail(:to => user.email, :subject => "Ticket ##{ticket.id}")
  end
  
  def ticket_updated ticket, user
	@ticket = ticket
	@user = user
	mail(:to => user.email, :subject => "Ticket ##{ticket.id}")
  end

  def loan_submitted user, loan
    @user = user
    @loan = loan
    mail(:to => user.email, :subject => "Tech Equipment Loan ##{loan.id}")
  end

  def tech_loan user, loan
    @user = user
    @loan = loan
    mail(:to => user.email, :subject => "Tech Equipment Loan ##{loan.id}")
  end

  def loan_approved user, loan
    @user = user
    @loan = loan
    mail(:to => user.email, :subject => "Tech Equipment Loan ##{loan.id}")
  end

  def loan_return user, loan
    @user = user
    @loan = loan
    mail(:to => user.email, :subject => "Tech Equipment Loan ##{loan.id}")
  end


end
