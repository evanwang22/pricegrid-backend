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
    ).to_h

    if response_is_error?(response)
      @search_error = error_keys(response)
      render 'search_error' and return
    end

    @search_result = select_keys(response)

  end


  private

  def select_keys(amazon_response)
    {
      image_url: amazon_response['ItemLookupResponse']['Items']['Item']['LargeImage']['URL'],
      name: amazon_response['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
    }
  end

  def error_keys(amazon_response)
    {
      message: amazon_response['ItemLookupResponse']['Items']['Request']['Errors']['Error']['Message']
    }
  end

  def response_is_error?(amazon_response)
    if amazon_response['ItemLookupResponse']['Items']['Request']['Errors']
      return true
    else
      return false
    end
  end

end
