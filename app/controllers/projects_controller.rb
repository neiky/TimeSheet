class ProjectsController < ApplicationController
	load_and_authorize_resource #, :except => [:accept_invitation, :reject_invitation]

  # GET /projects
  # GET /projects.json
  def index
    #@projects = []
    if current_user
      #@projects = current_user.projects.where("memberships.status >= ?", 1)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    #@project = Project.find(params[:id])
    @projectnote = Projectnote.new
    @projectnotes = @project.projectnotes.order("created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.js
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
        m = Membership.new(:user_id => current_user.id, :project_id => @project.id, :status => 3)	# status => 3: current_user is owner of project
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

    if params[:member_email] && params[:member_email] != ""
      @user = User.where(:email => params[:member_email]).first
      if @user
        m = Membership.where("user_id = #{@user.id} AND project_id = #{@project.id}")
        if m.count == 0
          m = Membership.new(:user_id => @user.id, :project_id => @project.id, :status => 0)	# status => 0: user is invited to project
          m.save
          ProjectMailer.project_invitation(current_user, @user, @project).deliver

          @message = Message.new
          @message.sender = current_user
          @message.recipient = @user
          if @message.save
            content = render_to_string :partial => "messages/project_invitation"
            @message.update_attributes(:content => content)
          end

          flash[:notice] = "User #{@user.email} added to project"
        else
          flash[:alert] = "User #{@user.email} is already member of the project"
        end
      else
        flash[:alert] = "User #{@user.email} not found"
      end
    end

    respond_to do |format|
      #@project.Client_id = cid
      @project.planned_efforts = planned_eff
      if @project.update_attributes(params[:project])
        if params[:commit] == "Add member"
          format.html { redirect_to action: "edit" }
          format.json { head :no_content }
        else
          format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @memberships = Membership.where(:project_id => params[:id])
    @memberships.each do |membership|
      membership.destroy
    end
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.js { render :text => "jQuery('#project_#{@project.id}').remove();" }
      format.json { head :no_content }
    end
  end

  def add_member
    puts params[:email]
    @user = User.where(:email => params[:email]).first
    if !@user
      puts "User not found!"
    else
      m = Membership.new(:user_id => @user.id, :project_id => @project.id, :status => 0)
      if m.save
        ProjectMailer.project_invitation(current_user, @user, @project).deliver
        respond_to do |format|
          format.html { render action: "edit" }
          format.js
        end
      end
    end
  end

  def remove_member
    @project = Project.find(params[:id])
    @user = User.find(params[:user_id])
    m = Membership.where("user_id = #{@user.id} AND project_id = #{@project.id}").first
    m.destroy
    respond_to do |format|
      format.html { redirect_to action: "edit", notice:  "User #{@user.email} removed from project" }
      format.js
      format.json { head :no_content }
    end
  end

  def accept_invitation
    @project = Project.find(params[:id])
    @user = current_user
    @owner = User.where(:id => Client.select("user_id").where(:id => @project.Client_id)).first
    m = Membership.where("user_id = #{@user.id} AND project_id = #{@project.id}").first
    if m
      m.update_attributes(:status => 1)  # status => 1: confirmed project membership
      ProjectMailer.project_invitation_accepted(@owner, @user, @project).deliver
      if params[:message_id]
        msg = Message.find(params[:message_id])
        msg.destroy
      end

      @message = Message.new
      @message.sender = @user
      @message.recipient = @owner
      @message.content = render_to_string :partial => "messages/project_invitation_accepted"

      @message.save

      respond_to do |format|
        format.html { redirect_to projects_url, notice: 'Successfully joined the project.' }
        format.json { head :no_content }
      end
    end
  end

  def reject_invitation
    @project = Project.find(params[:id])
    #authorize! :reject_invitation, @project
    @user = current_user
    @owner = User.where(:id => Client.select("user_id").where(:id => @project.Client_id)).first
    m = Membership.where("user_id = #{@user.id} AND project_id = #{@project.id}").first
    respond_to do |format|
      if m
        m.destroy
        m.send_rejection_mail

        if params[:message_id]
          msg = Message.find(params[:message_id])
          msg.destroy
        end

        @message = Message.new
        @message.sender = @user
        @message.recipient = @owner
        @message.content = render_to_string :partial => "messages/project_invitation_rejected"

        @message.save

        format.html { redirect_to projects_url, notice: 'Successfully rejected the project invitation.' }
        format.json { head :no_content }
      else
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
    end
  end
end