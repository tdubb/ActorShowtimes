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

  it "is invalid without a movie_db_id" do 
    FactoryGirl.build(:actor, movie_db_id: nil).should_not be_valid 
  end

  describe "#new" do
    it "returns a new Actor object" do
      actor = FactoryGirl.build(:actor)
      actor.should be_an_instance_of Actor
    end
  end

  describe "#name" do
    it "returns the correct name" do
      actor = FactoryGirl.build(:actor, name: "Joe")
      actor.name.should eql "Joe"
    end
  end  

  describe "#picture_url" do
    it "returns the correct picture_url" do
      actor = FactoryGirl.build(:actor, picture_url: "http://some_image.jpg")
      actor.picture_url.should eql "http://some_image.jpg"
    end
  end 
 
  describe "#movie_db_id" do
    it "returns the correct namemoie_db_id" do
      actor = FactoryGirl.build(:actor, movie_db_id: "55")
      actor.movie_db_id.should eql "55"
    end
  end 

  describe "#save" do
    it "should not save actor without name and movie_db_id" do
      actor = Actor.new
      assert !actor.save, "Saved the Actor without a name and movie_db_id"
    end
  end
end
