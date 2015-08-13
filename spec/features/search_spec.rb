require "rails_helper"

feature 'Searching for a product' do
  scenario 'User loads the application' do
    When 'user visits homepage'
    Then 'user sees application'
  end

  scenario 'User searches for a product' do
    When 'user visits homepage'
    Then 'user sees search field'
    When 'user searches with a product id'
    Then 'user sees details for the product'
  end

  scenario "User searches for a product which doesn't exist" do
    When 'user visits homepage'
    Then 'user sees search field'
    When 'user searches with an invalid product id'
    Then 'user sees an error message'
  end

  def user_visits_homepage
    visit root_path
  end

  def user_sees_application
    expect(page).to have_text('Pricegrid')
    expect(page).to have_text('See color and size combinations for Amazon products')
  end

  def user_sees_search_field
    expect(page).to have_selector('input#search')
  end

  def user_searches_with_a_product_id
    fill_in 'search', with: 'B00PZB5LBM'
    click_on 'Search'
  end

  def user_sees_details_for_the_product
    expect(page).to have_text('China Gold Panda')
    expect(page).to have_selector('img.search-result')
  end

  def user_searches_with_an_invalid_product_id
    fill_in 'search', with: 'K00PZB5LBM'
    click_on 'Search'
  end

  def user_sees_an_error_message
    expect(page).to have_text('Sorry, the product ID you searched for cannot be found. Please try your search again')
  end
end

