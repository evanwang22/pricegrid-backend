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
    let(:vacuum_response) {
      instance_double(Vacuum::Response)
    }

    let(:vacuum_request) {
      instance_double(Vacuum::Request,
        item_lookup: vacuum_response,
        :associate_tag= => 'tag'
      )
    }

    before do
      allow(Vacuum).to receive(:new).and_return(vacuum_request)
      allow(vacuum_response).to receive(:body).and_return(xml_data)
      get :search, search: '123ABC456'
    end

    context 'when the product id corresponds to an amazon product' do
      let(:xml_data) {
        IO.read(Rails.root.join("spec", "fixtures", "amazon_response.xml"))
      }

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
          imageUrl: "http://ecx.images-amazon.com/images/I/31otfvpPU6L.jpg",
          name: "Contigo Cortland Water Bottle, 24-Ounce, Radiant Orchid"
        })
      end

      it 'renders the home#search template' do
        expect(response).to render_template("search")
      end
    end

    context 'when the product id does not correspond to a real amazon product' do
      let(:xml_data) {
        IO.read(Rails.root.join("spec", "fixtures", "amazon_error.xml"))
      }

      it 'searches for a product using the amazon product API' do
        expect(vacuum_request).to have_received(:item_lookup).with(
          query: {
            'ItemId' => '123ABC456',
            'ResponseGroup' => 'ItemAttributes,Images'
          }
        )
      end

      it 'assigns the amazon error response' do
        expect(assigns(:search_result)[:error]).to include(
          "123ABC456 is not a valid value for ItemId."
        )
      end

      it 'renders the home#search_error template' do
        expect(response).to render_template("search_error")
      end
    end
  end
end
