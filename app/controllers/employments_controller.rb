class EmploymentsController < ApplicationController
	load_and_authorize_resource
	
	def index
		if current_user
    	@employment = Employment.where(:employee_id => current_user.id).first
    	if !@employment
	    	#@self_employment = Employment.where("employer_id = ? AND employee_id = ?", current_user.id, 0).first
	      #if !@self_employment
	      #	@self_employment = Employment.new(:employer_id => current_user.id, :employee_id => 0, :workingtime_per_day => 28800, :employment_date => Date.today, :accepted => true)
	      #	if @self_employment.save
				#		flash[:notice] = "Employment settings created for you!"      		
	      #	else
	      #		flash[:alert] = "Failed creating employment settings for you!"
	      #	end
	      #end
    	
    		@employments = Employment.includes(:employee).where(:employer_id => current_user.id)
    		
    		respond_to do |format|
		      format.html # index.html.erb
		      format.json { render json: @employments }
		    end
    	else
    		respond_to do |format|
		      format.html { redirect_to @employment }
		      format.json { render json: @employment }
		    end
    	end
    else
    	respond_to do |format|
	      format.html { redirect_to root_url }
	      format.json { head :no_content }
	    end
    end
	end
	
	def show
		if current_user
      @employment = Employment.includes(:employee, :employer).find(params[:id])

      respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @employment }
	    end
    end
	end
	
	def new
		@employment = Employment.new
	end
	
	def edit
		@employment = Employment.includes(:employee, :employer).find(params[:id])
		authorize! :edit, @employment
		if @employment.employer == current_user
			if @employment.employee_id > 0
      	@employee = @employment.employee
      else
      	@employee = current_user
      end
		else
			redirect_to root_url
		end
	end
	
  def create
    employee = User.where(:email => params[:employee_email]).first
    if employee
      timePerDay = params[:hours].to_i*3600 + params[:minutes].to_i*60
      #@employment = Employment.new(:employer_id => current_user.id, :employee_id => employee.id, :workingtime_per_day => timePerDay, :num_vacation_days => params[:employment][:num_vacation_days], :employment_date => params[:employment][:employment_date])
      @employment = Employment.new(:employer_id => current_user.id, :employee_id => employee.id, :workingtime_per_day => timePerDay)
      @employment.update_attributes(params[:employment])
      if @employment.save
        employee.update_attributes(:employment_id => @employment.id)
        @message = Message.new
        @message.sender = current_user
        @message.recipient = employee
        if @message.save
          content = render_to_string :partial => "messages/employee_invitation"
          @message.update_attributes(:content => content)
        end

        flash[:notice] = "Added employee."
        redirect_to employments_path
      else
        flash[:alert] = "Unable to add employee."
        redirect_to root_url
      end
    else
      flash[:alert] = "Unable to add employee."
      redirect_to root_url
    end
  end

  def update
    @employment = Employment.includes(:employer).find(params[:id])

    case params[:step]
    when "accept"
      if @employment.update_attributes(:accepted => true)
        if params[:message_id]
          msg = Message.find(params[:message_id])
          msg.destroy
        end

        # delete self employment of employee
        self_employment = Employment.find_by_employer_id(current_user.id)
        self_employment.destroy if self_employment

        employer = Employment.find_by_employee_id(current_user.id).employer
        current_user.update_attributes(:company => employer.company)

        @message = Message.new
        @message.sender = current_user
        @message.recipient = @employment.employer
        if @message.save
          content = render_to_string :partial => "messages/employee_invitation_accepted"
          @message.update_attributes(:content => content)
        end

        respond_to do |format|
          format.html { redirect_to current_user, notice: 'Employment invitation was successfully accepted.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to messages_path }
          format.json { render json: @employment.errors, status: :unprocessable_entity }
        end
      end
    when "reject"
      @employment.destroy

      if params[:message_id]
        msg = Message.find(params[:message_id])
        msg.destroy
      end

      content = render_to_string :partial => "messages/employee_invitation_rejected"
      @message = Message.new
      @message.sender = current_user
      @message.recipient = @employment.employer
      @message.content = content

      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Employment invitation was successfully rejected.' }
        format.json { head :no_content }
      end
    else
      timePerDay = params[:hours].to_i*3600 + params[:minutes].to_i*60
      if @employment.update_attributes(:workingtime_per_day => timePerDay, :num_vacation_days => params[:employment][:num_vacation_days])
        respond_to do |format|
          format.html { redirect_to @employment, notice: 'Employment was successfully updated.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render action: "edit" }
          format.json { render json: @employment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @employment = Employment.find(params[:id])
    @employment.destroy

    respond_to do |format|
      format.html { redirect_to employments_path }
      format.json { head :no_content }
    end
  end

end
