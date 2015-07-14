require 'rails_helper'

describe HomeController, type: :controller do
  describe "GET index" do
    it "renders the home#index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end