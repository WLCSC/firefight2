class LoansController < ApplicationController
	before_filter :check_for_admin, :only => ['edit', 'update', 'destroy']
	before_filter :check_for_user
	# GET /loans
	# GET /loans.json
	def index
		@loans = Loan.all

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @loans }
		end
	end

	# GET /loans/1
	# GET /loans/1.json
	def show
		@loan = Loan.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @loan }
		end
	end

	# GET /loans/new
	# GET /loans/new.json
	def new
		@loan = Loan.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @loan }
		end
	end

	# GET /loans/1/edit
	def edit
		@loan = Loan.find(params[:id])
	end

	# POST /loans
	# POST /loans.json
	def create
		@loan = Loan.new(params[:loan])
		respond_to do |format|
			if @loan.save
				begin
				MailMan.loan_submitted(current_user.id, @loan.id).deliver
				rescue => exc
					ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
				end
				User.where(:administrator => true).each do |u|
					begin
					MailMan.tech_loan(u.id, @loan.id).deliver
					rescue => exc
						ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
					end
				end
				format.html { redirect_to @loan, notice: 'Loan was successfully created.' }
				format.json { render json: @loan, status: :created, location: @loan }
			else
				format.html { render action: "new" }
				format.json { render json: @loan.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /loans/1
	# PUT /loans/1.json
	def update
		@loan = Loan.find(params[:id])

		respond_to do |format|
			if @loan.update_attributes(params[:loan])
				format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @loan.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /loans/1
	# DELETE /loans/1.json
	def destroy
		@loan = Loan.find(params[:id])
		@loan.destroy

		respond_to do |format|
			format.html { redirect_to loans_url }
			format.json { head :no_content }
		end
	end

	def approve
		@loan = Loan.find(params[:id])
		if params[:commit] == "Approve"
			@loan.approved = true
	
			if params[:asset]
			params[:asset].each do |k,v|
				r = Return.create! :loan_id => @loan.id, :asset_id => v, :returned => false
			end
			end
			
			begin
			MailMan.loan_approved(@loan.user.id, @loan.id).deliver
			rescue => exc
				ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
			end
		else
			@loan.approved = false
			begin
			MailMan.loan_denied(@loan.user.id, @loan.id).deliver
			rescue => exc
				ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
			end
		end

		@loan.save
		redirect_to @loan, :notice => "#{@loan.approved ? "Approved" : "Denied"} loan"
	end

	def return
		@loan = Loan.find(params[:id])

		params[:rx].each do |i|
			r = Return.find i
			r.returned = true
			r.save
		end

		begin
		MailMan.loan_return(@loan.user.id, @loan.id).deliver
		rescue => exc
			ExceptionNotifier::Notifier.exception_notification(request.env, exc, :data => {:message => "failed to deliver mail"}).deliver
		end
		redirect_to @loan, :notice => "Returned equipment"
	end
end
