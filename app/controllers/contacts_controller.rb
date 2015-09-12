class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    #@contacts = []
    if current_user
    #  @contacts = Contact.order("name ASC").where(:client_id => Client.where(:user_id => current_user.id))
    end

    if params[:id]
      @contact = Contact.find(params[:id])
      authorize! :read, @contact
    else
      @contact = @contacts.first
    end

    @subtitle = "Kontaktliste"
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :action => 'show'}
      format.json { render json: @clients }
    end
  end

  def show
    #@contacts = Contact.all
    #@contact = Contact.find(params[:id])

    respond_to do |format|
      format.html { redirect_to :action => "index", :id => params[:id] }
      format.js
      format.json { render json: @contact }
    end
  end

  def new
    @contact = Contact.new
    @contact = Contact.new(:client => Client.find(params[:client_id].to_i)) if params[:client_id]
    #@contact.client_id = params[:client_id].to_i

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @contact }
    end
  end

  # GET /clients/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    client_id = params[:contact].delete(:client_id)
    @contact = Contact.new(params[:contact])
    @contact.client = Client.find(client_id.to_i) if client_id.to_i > 0
    @contact.user = current_user

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_url, :id => @contact.id, notice: 'Contact was successfully created.' }
        format.js
        format.json { render json: @contact, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.js { render :action => 'new'}
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    client_id = params[:contact].delete(:client_id)
    @contact = Contact.find(params[:id])
    @contact.client = Client.find(client_id.to_i)

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.js
      format.json { head :no_content }
    end
  end
end
