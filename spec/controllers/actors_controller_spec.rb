#spec/controllers/actors_controller_apec.rb
require 'spec_helper'

describe ActorsController do

  describe "GET index" do
    # it "assigns @teams" do
    #   team = Team.create
    #   get :index
    #   expect(assigns(:teams)).to eq([team])
    # end

    # it "renders the index template" do
    #   get :index
    #   expect(response).to render_template("index")
    # end

    it "should get show" do
      get :show
      assert_response :success
    end
    
  end

end

# new
# create
# index
# show
# destroy