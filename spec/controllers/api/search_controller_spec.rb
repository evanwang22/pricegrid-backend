require 'rails_helper'

describe Api::SearchController, type: :controller do

  describe "GET index" do
    let(:vacuum_response) {
      instance_double(Vacuum::Response)
    }

    let(:vacuum_request) {
      instance_double(Vacuum::Request,
        item_lookup: vacuum_response,
        :associate_tag= => 'tag'
      )
    }

    let(:xml_data) {
      IO.read(Rails.root.join("spec", "fixtures", "amazon_response.xml"))
    }

    before do
      allow(Vacuum).to receive(:new).and_return(vacuum_request)
      allow(vacuum_response).to receive(:body).and_return(xml_data)
      get :index, format: 'json', query: '123ABC456'
    end

    it 'searches using the amazon product API' do
      expect(vacuum_request).to have_received(:item_lookup).with(
        query: {
          'ItemId' => '123ABC456',
          'ResponseGroup' => 'ItemAttributes,Images,VariationSummary'
        }
      )
    end

    context 'when the product id corresponds to an amazon product' do
      it 'returns the amazon product response' do
        search_result = JSON.parse(response.body)
        expect(search_result).to eq({
          "imageUrl" => "http://ecx.images-amazon.com/images/I/31otfvpPU6L.jpg",
          "name" => "Contigo Cortland Water Bottle, 24-Ounce, Radiant Orchid",
          "variations" => true
        })
      end
    end

    context 'when the product id does not correspond to a real amazon product' do
      let(:xml_data) {
        IO.read(Rails.root.join("spec", "fixtures", "amazon_error.xml"))
      }

      it 'returns the amazon error response' do
        search_result = JSON.parse(response.body)
        expect(search_result["error"]).to include(
          "123ABC456 is not a valid value for ItemId."
        )
      end
    end
  end
end
