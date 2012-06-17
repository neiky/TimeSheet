class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = []
    if current_user
      @projects = current_user.projects
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    #cid = params[:project].delete(:Client)
    #puts cid.to_s
    #puts params[:planned_efforts_days].to_s + ", " + params[:planned_efforts_hours].to_s
    planned_eff = params[:planned_efforts_days].to_i*86400 + params[:planned_efforts_hours].to_i*3600
    #puts planned_eff.to_s
    @project = Project.new(params[:project])
    #@project.Client_id = cid
    @project.planned_efforts = planned_eff

    respond_to do |format|
      if @project.save
        #also create membership
        m = Membership.new(:user_id => current_user.id, :project_id => @project.id)
        if m.save
          format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
          format.json { render json: @project, status: :created, location: @project }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    #cid = params[:project].delete(:Client)
    #puts cid.to_s
    planned_eff = params[:planned_efforts_days].to_i*86400 + params[:planned_efforts_hours].to_i*3600
    
    respond_to do |format|
      #@project.Client_id = cid
      @project.planned_efforts = planned_eff
      if @project.update_attributes(params[:project])
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.js { render :text => "jQuery('#project_#{@project.id}').remove();" }
      format.json { head :no_content }
    end
  end
end
