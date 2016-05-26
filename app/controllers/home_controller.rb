class HomeController < ApplicationController
  def index
  end

  def search
    product_id = params[:search]
    request = Vacuum.new
    request.associate_tag = 'tag'

    response = request.item_lookup(
      query: {
        'ItemId' => product_id,
        'ResponseGroup' => 'ItemAttributes,Images'
      }
    )
    @search_result = parse(response.body)

    if @search_result[:error].present?
      render 'search_error' and return
    end
  end

  private

  def parse(body)
    doc = Nokogiri::XML(body)
    nodes = {
      error: doc.xpath("//xmlns:Errors//xmlns:Message"),
      name: doc.xpath("//xmlns:ItemAttributes//xmlns:Title"),
      imageUrl: doc.xpath("//xmlns:Item/xmlns:LargeImage/xmlns:URL")
    }
    {}.tap do |search_result|
      nodes.each do |k, v|
        search_result[k] = v.text if v.present?
      end
    end
  end
end
