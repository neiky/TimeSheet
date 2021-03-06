class ClientsController < ApplicationController
  load_and_authorize_resource

  # GET /clients
  # GET /clients.json
  def index
    #@clients = []
    #if current_user
    #  @clients = Client.order("name ASC").where(:user_id => current_user.id)
    #end
    if params[:id]
      @client = Client.find(params[:id])
      authorize! :read, @client
    else
      @client = @clients.first
    end

    puts @client

    @subtitle = "Kundenliste"
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :action => 'show'}
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    #@client = Client.find(params[:id])

    respond_to do |format|
      format.html { redirect_to :action => "index", :id => params[:id] }  # show.html.erb
      format.js
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    #@client = Client.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.js
    end
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])
    puts current_user.id
    @client.user_id = current_user.id

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.js
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.js
      format.json { head :no_content }
    end
  end
end
