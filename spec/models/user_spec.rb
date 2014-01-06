#spec/models.user.rb
require 'spec_helper'

describe User do
  # before(:each) do
  # end

  it "has a valid factory" do 
    FactoryGirl.create(:user).should be_valid 
  end 

  it "is invalid without a email" do 
    FactoryGirl.build(:user, email: nil).should_not be_valid 
  end

  it "is invalid without a password" do 
    FactoryGirl.build(:user, password: nil).should_not be_valid 
  end

  it "should create a new instance of a user given valid attributes" do
    @user_attr = FactoryGirl.attributes_for(:user)
    User.create!(@user_attr)
  end
end

