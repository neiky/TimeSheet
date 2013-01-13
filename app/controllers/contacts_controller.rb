class ContactsController < ApplicationController
	def index
    @contacts = []
    if current_user
      @contacts = Contact.order("name ASC").where(:client_id => Client.where(:user_id => current_user.id))
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end
	
	def show
		@contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
	end
	
	def new
    @contact = Contact.new(:client => Client.find(params[:client_id].to_i))
    #@contact.client_id = params[:client_id].to_i

    respond_to do |format|
      format.html # new.html.erb
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
    @contact.client = Client.find(client_id.to_i)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @client }
      else
        format.html { render action: "new" }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.js { render :text => "jQuery('#contact_#{@contact.id}').remove();" }
      format.json { head :no_content }
    end
  end
end
