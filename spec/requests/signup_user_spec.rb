require 'spec_helper'

describe "SignupUser" do
  describe "User signup" do
    it "should show signup form" do
      visit root_path
      within :css, "#content" do
        click_link "Sign up"
      end
      fill_in "user_email", :with => "bla@example.com"
      fill_in "user_password", :with => "test1234"
      fill_in "user_password_confirmation", :with => "test1234"

      expect {
        expect {
          click_button "Sign in"
        }.to change(User, :count).by(1)
      }.to change(ActionMailer::Base.deliveries, :count).by(1)

      User.last.confirmed_at.should eq(nil)

      email = ActionMailer::Base.deliveries.last

      email.to.should eq(["bla@example.com"])

      email.body.should include(User.last.confirmation_token)

      visit URI::extract(email.body.to_s).find{|uri| uri.include?(User.last.confirmation_token)}
      User.last.confirmed_at.should_not eq(nil)
    end
  end
  describe "User delete" do
    it "should not allow user to sign in after deletion" do
      login_as :user
      click_link @user.get_full_name
      click_link 'user_edit'
      #page.evaluate_script('window.confirm = function() { return true; }')
      #click_link 'Cancel my account'
      delete user_path(@user)
      @user.reload
      @user.inactive.should eq(true)
    end
  end
end
