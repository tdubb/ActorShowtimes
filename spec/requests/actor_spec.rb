require 'spec_helper'

describe "Actors" do
  describe "GET /actors" do
    # it "if user signed in responds 200" do
    #   # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    #   get actors_path
    #   response.status.should eql (200)
    # end

    it "redirect to 302 if no user signed in" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get actors_path
      response.status.should eql (302)
    end
  end
end
