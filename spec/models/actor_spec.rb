#spec/models.user.rb
require 'spec_helper'

describe Actor do
  # before :each do
  #   @actor = Actor.new "Name" , "Picture_url" #, "movie_db_id"
  # end

  it "has a valid factory" do 
    FactoryGirl.create(:actor).should be_valid 
  end 

  it "is invalid without a name" do 
    FactoryGirl.build(:actor, name: nil).should_not be_valid 
  end

  describe "#new" do
    it "returns a new Actor object" do
      @actor = Actor.new 
      @actor.should( be_an_instance_of( Actor) )
    end
  end
end
