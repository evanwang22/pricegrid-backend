class Api::SearchController < ApplicationController
  respond_to :json

  def index
    product_id = params[:query]
    request = Vacuum.new
    request.associate_tag = 'tag'

    response = request.item_lookup(
      query: {
        'ItemId' => product_id,
        'ResponseGroup' => 'ItemAttributes,Images,VariationSummary'
      }
    )

    respond_with(parse(response.body).to_json)
  end

  private

  def parse(body)
    doc = Nokogiri::XML(body)
    nodes = {
      error: doc.xpath("//xmlns:Errors//xmlns:Message"),
      name: doc.xpath("//xmlns:ItemAttributes//xmlns:Title"),
      imageUrl: doc.xpath("//xmlns:Item/xmlns:LargeImage/xmlns:URL"),
    }

    search_result = {}
    search_result[:variations] = true if doc.xpath("//xmlns:Item/xmlns:VariationSummary")

    nodes.each do |k, v|
      search_result[k] = v.text if v.present?
    end

    return search_result
  end
end
