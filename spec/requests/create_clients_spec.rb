require 'spec_helper'

describe "CreateClients" do
  describe "GET clients/new" do
    it "should show new client form" do
      login_as :user
      visit new_client_path
      fill_in "client_name", :with => "Hallo"
      fill_in "client_description", :with => "Ich bin ein Testkunde"
      expect {
        click_button "Create Client"
      }.to change(Client, :count).by(1)
      #save_and_open_page
      page.should have_content("Client was successfully created.")
    end
  end
end
