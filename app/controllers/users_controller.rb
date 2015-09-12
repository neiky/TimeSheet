class UsersController < ApplicationController

  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    if params[:id]
      @user = User.includes(:employment).find(params[:id])
    else
      @user = User.includes(:employment).find(current_user.id)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

end
