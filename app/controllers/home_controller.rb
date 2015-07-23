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

    @search_result = select_keys(response.to_h)
  end


  private

  def select_keys(amazon_response)
    {
      image_url: amazon_response['ItemLookupResponse']['Items']['Item']['LargeImage']['URL'],
      name: amazon_response['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
    }
  end

end
