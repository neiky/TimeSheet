require 'spec_helper'

describe User do
  it { should belong_to(:employment) }
  it "should create employment after save" do
    user = FactoryGirl.create(:user)
    user.employment.should_not be(nil)
  end
  it "should build correct full name" do
    user = User.new(:firstname => "Hans", :name => "Wurst")
    user.get_full_name.should eq("Hans Wurst")
  end
  it "should set user inactive on destroy" do
    user = FactoryGirl.create(:user)
    user.destroy
    user.inactive.should eq(true)
    user.destroyed?.should eq(false)
  end
  it "should destroy inactive user" do
    user = FactoryGirl.create(:user)
    user.destroy
    user.destroy
    user.destroyed?.should eq(true)
  end
end
