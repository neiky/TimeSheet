class ProjectnotesController < ApplicationController
	def index
		if params[:project_id] and Membership.where(:user_id => current_user.id, :project_id => [:project_id])
			if params[:time]
				t = Time.at(params[:time].to_i)
				@projectnotes = Projectnote.where("project_id = ? AND created_at > ?", params[:project_id], t).order("created_at DESC")
			else
				@projectnotes = Projectnote.where(:project_id => params[:project_id]).order("created_at DESC")
			end
			respond_to do |format|
    	  format.html { render :partial => @projectnotes }
    	  format.json { render json: @projectnotes }
    	end
    else
    	respond_to do |format|
    	  format.html { redirect_to :root }
    	end
		end
	end

  def create
  	project = Project.find(params[:project_id])
  	@projectnote = Projectnote.new
  	@projectnote.content = params[:projectnote]
  	@projectnote.sender = current_user
  	@projectnote.project = project
  	
  	respond_to do |format|
  		if @projectnote.save
  			@projectnotes = Projectnote.where(:project_id => project).order("created_at DESC")
	      format.html { redirect_to project }
	      format.json { render json: @project, status: :created, location: @project }
	      format.js
	    else
	    	format.html { redirect_to projects_url }
      end
    end
  end
end
