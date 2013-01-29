require "spec_helper"
module LoginHelpers
  include Capybara::DSL

  def login_as(sym)
    logout if @user
    @user = FactoryGirl.create(sym)
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button "Sign in"
  end

  def logout(user = @current_user)
    Capybara.reset_sessions!
    visit destroy_user_session_url
  end
end