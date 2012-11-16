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
      @start_date = Date.today().change(:day => 1)
      @end_date = Date.today()
      @end_date = @end_date.change(:month => @end_date.month+1, :day => 1)-1
    end
    
    @timerecords = Timerecord.all
    
    @timerecords = Timerecord.order("start ASC")
    @timerecords = @timerecords.in_period(@start_date, @end_date)
    #@timerecords = @timerecords.by_project_id(params[:filter_project]) unless params[:filter_project_active].blank?
		@timerecords = @timerecords.by_project_id(params[:filter_project]) unless params[:filter_project] == ""
    #@timerecords = @timerecords.by_user_id(params[:filter_user]) unless params[:filter_user_active].blank?
		@timerecords = @timerecords.by_user_id(params[:filter_user]) unless params[:filter_user] == ""
    
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
