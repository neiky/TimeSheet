require 'spec_helper'

describe "users/index" do
  before(:each) do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    @users = [user1, user2]
  end

  it "should render list of users" do
    render
    assert_select("table", :count => 1)
  end
end
