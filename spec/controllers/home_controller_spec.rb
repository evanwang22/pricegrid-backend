require 'rails_helper'

describe HomeController, type: :controller do

  describe "GET index" do

    before do
      get :index
    end

    it 'renders the home#index template' do
      expect(response).to render_template("index")
    end
  end

  describe "GET search" do

    let(:item_data) { {} }

    let(:vacuum_request) {
      object_double(Vacuum.new,
        item_lookup: {
          "ItemLookupResponse"=> {
            "Items"=> item_data,
          }
        },
        :associate_tag= => 'tag'
      )
    }

    before do
      allow(Vacuum).to receive(:new).and_return(vacuum_request)
      get :search, search: '123ABC456'
    end

    context 'when the product id corresponds to an amazon product' do
      let(:item_data) { {
        "Item"=>{
          "LargeImage"=> {
            "URL"=>"http://fun.com/funImage"
          },
          "ItemAttributes"=> {
            "Title"=>"Fun stuff"
          }
        },
        "Request"=> {}
      } }

      it 'searches for a product using the amazon product API' do
        expect(vacuum_request).to have_received(:item_lookup).with(
          query: {
            'ItemId' => '123ABC456',
            'ResponseGroup' => 'ItemAttributes,Images'
          }
        )
      end

      it 'assigns the amazon product response' do
        expect(assigns(:search_result)).to eq({
          image_url: "http://fun.com/funImage",
          name: "Fun stuff"
        })
      end

      it 'renders the home#search template' do
        expect(response).to render_template("search")
      end
    end

    context 'when the product id does not correspond to a real amazon product' do
      let(:item_data) { {
        "Request"=>{
          "Errors"=>{
            "Error"=> {
              "Message"=>"123ABC456 is not a valid value for ItemId."
            }
          }
        }
      } }

      it 'searches for a product using the amazon product API' do
        expect(vacuum_request).to have_received(:item_lookup).with(
          query: {
            'ItemId' => '123ABC456',
            'ResponseGroup' => 'ItemAttributes,Images'
          }
        )
      end

      it 'assigns the amazon error response' do
        expect(assigns(:search_error)).to eq({
          message: "123ABC456 is not a valid value for ItemId.",
        })
      end

      it 'renders the home#search_error template' do
        expect(response).to render_template("search_error")
      end
    end

  end
end
