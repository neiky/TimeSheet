require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET index" do
    it "should allow user only to see himself" do
      user2 = FactoryGirl.create(:user)
      get :index, {}
      assigns(:users).should eq([@user])
    end
    it "should allow admin to see all users" do
      @user.role = "admin"
      @user.save!
      user2 = FactoryGirl.create(:user)
      get :index, {}
      assigns(:users).should eq([@user, user2])
    end
  end

  describe"GET show" do
    it "should show user to himself" do
      get :show, { :id => @user.id }
      assigns(:user).should eq(@user)
      response.should be_successful
    end
    it "should not show another user" do
      user2 = FactoryGirl.create(:user)
      get :show, { :id => user2.id }
      response.should redirect_to root_url
    end
    it "should show another user to admin" do
      @user.role = "admin"
      @user.save!
      user2 = FactoryGirl.create(:user)
      get :show, { :id => user2.id }
      assigns(:user).should eq(user2)
      response.should be_successful
      response.should render_template("show")
    end
  end
end
