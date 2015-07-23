require 'rails_helper'

describe HomeController, type: :controller do

  describe "GET index" do

    before do
      get :index
    end

    it "renders the home#index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET search" do

    let(:vacuum_request) {
      object_double(Vacuum.new,
        item_lookup: {
          "ItemLookupResponse"=> {
            "Items"=> {
              "Item"=> {
                "LargeImage"=> {
                  "URL"=>"http://fun.com/funImage"
                },
                "ItemAttributes"=> {
                  "Title"=>"Fun stuff"
                }
              }
            }
          }
        },
        :associate_tag= => 'tag'
      )
    }

    before do
      allow(Vacuum).to receive(:new).and_return(vacuum_request)
      get :search, search: '123ABC456'
    end

    it "searches for a product using the amazon product API" do
      expect(vacuum_request).to have_received(:item_lookup).with(
        query: {
          'ItemId' => '123ABC456',
          'ResponseGroup' => 'ItemAttributes,Images'
        }
      )
    end

    it "assigns the amazon product response" do
      expect(assigns(:search_result)).to eq({
        image_url: "http://fun.com/funImage",
        name: "Fun stuff"
      })
    end

    it "renders the home#search template" do
      expect(response).to render_template("search")
    end
  end
end
