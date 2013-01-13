class TimerecordsController < ApplicationController
  def index
    params[:user_id] = current_user.id
    puts params
    @timerecords = Timerecord.get_timerecords(params)
    @timerecord = Timerecord.new

    @timerecords_total_duration = Timerecord.get_sum_duration(@timerecords)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @timerecords }
    end
  end

  def analyze
		puts params
    if params[:date_start]
      @start_date = Date.strptime(params[:date_start], '%Y-%m-%d')
      @end_date = Date.strptime(params[:date_end], '%Y-%m-%d')
    else
      @start_date = Date.today().beginning_of_month
      @end_date = Date.today().end_of_month
    end

    #@timerecords = Timerecord.where(:Project_id => Membership.select("Project_id").where(:User_id => current_user.id))
		#@timerecords = Timerecord.where("Project_id = ? AND User_id = ?", Project.where(:Client_id => Client.where("User_id != ?", current_user.id)), current_user.id)
		Timerecord.where(:Project_id => Project.where(:Client_id => Client.where(:User_id => current_user.id)))
		@timerecords = Timerecord.where("(Project_id IN (?) AND User_id = ?) OR Project_id IN (?)", Membership.select("Project_id").where(:User_id => current_user.id, :status => 1..2).map(&:project_id), current_user.id, Membership.select("Project_id").where(:User_id => current_user.id, :status => 3).map(&:project_id) )
		#Project.where(:Client_id => Client.where("User_id != ?", current_user.id))
		#Project.where(:Client_id => Client.where(:User_id => current_user.id))
    #@timerecords = @timerecords.order("start ASC")

    @timerecords = @timerecords.in_period(@start_date, @end_date)

    #@timerecords = @timerecords.by_project_id(params[:filter_project]) unless params[:filter_project_active].blank?
		@timerecords = @timerecords.by_project_id(params[:filter_project]) if (params[:filter_project] && params[:filter_project] != "")
    #@timerecords = @timerecords.by_user_id(params[:filter_user]) unless params[:filter_user_active].blank?
		@timerecords = @timerecords.by_user_id(params[:filter_user]) if (params[:filter_user] && params[:filter_user] != "")

    @timerecords_total_duration = Timerecord.get_sum_duration(@timerecords)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @timerecords }
    end
  end

  def new
    @timerecord = Timerecord.new
  end

    # GET /timerecords/1/edit
  def edit
    @timerecord = Timerecord.find(params[:id])
    respond_to do |format|
        format.html
        format.js
    end
  end

  # PUT /timerecords/1
  # PUT /timerecords/1.json
  def update
  	pid = params[:timerecord].delete(:Project)
  	startDate = Date.strptime(params[:dateSelect], '%Y-%m-%d').to_datetime.change(:hour => params[:start_hour].to_i, :min => params[:start_minute].to_i)
    endDate = Date.strptime(params[:dateSelect], '%Y-%m-%d').to_datetime.change(:hour => params[:end_hour].to_i, :min => params[:end_minute].to_i)
    if endDate > startDate
	    @timerecord = Timerecord.find(params[:id])
	    @timerecord.description = params[:timerecord][:description]
	    @timerecord.Project_id = pid
	    @timerecord.start = startDate
	    @timerecord.end = endDate
	    @timerecord.duration = @timerecord.end - @timerecord.start

	    respond_to do |format|
	   		if @timerecord.save
	      		format.html { redirect_to timerecords_path(:date_search => params[:dateSelect]), notice: 'Timerecord was successfully updated.' }
	      	else
	      		format.html { redirect_to timerecords_path(:date_search => params[:dateSelect]), error: 'Failed updating timerecord!' }
	    	end
	   	end
    else
		respond_to do |format|
	      format.html { redirect_to timerecords_path(:date_search => params[:date]), alert: 'Failed updating timerecord!' }
	    end
    end
  end

  def create
    pid = params[:timerecord].delete(:Project)
    startDate = Date.strptime(params[:date], '%Y-%m-%d').to_datetime.change(:hour => params[:start_hour].to_i, :min => params[:start_minute].to_i)
    endDate = Date.strptime(params[:date], '%Y-%m-%d').to_datetime.change(:hour => params[:end_hour].to_i, :min => params[:end_minute].to_i)
    if endDate < startDate
      endDate.advance(:days => 1)
    end
    @timerecord = Timerecord.new
    @timerecord.User = current_user
    @timerecord.Project_id = pid
    @timerecord.description = params[:timerecord][:description]
    @timerecord.start = startDate
    @timerecord.end = endDate
    @timerecord.duration = @timerecord.end - @timerecord.start
    if @timerecord.duration > 0 and @timerecord.save!
			puts params
			params[:user_id] = current_user.id
      @timerecords = Timerecord.get_timerecords(params)
      #flash[:notice] = "Timerecord has been successfully created."
      respond_to do |format|
        format.html { redirect_to timerecords_path(:date_search => params[:date]) }
        format.js

        #format.js { render :text => "$('#timerecordsList').html('bla');" }
      end
    else
      #render :action => "new"
    end
  end

  def destroy
	@timerecord = Timerecord.find(params[:id])
    @timerecord.destroy

    arg = { :date => @timerecord.start.strftime("%Y-%m-%d"), :user_id => current_user.id }
    @timerecords = Timerecord.get_timerecords(arg)

    respond_to do |format|
      format.html { redirect_to timerecords_url }
      format.js
      format.json { head :no_content }
    end
  end
end
