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

  def user_visits_homepage
    visit root_path
  end

  def user_sees_application
    expect(page).to have_text("Pricegrid")
    expect(page).to have_text("See color and size combinations for Amazon products")
  end

  def user_sees_search_field
    expect(page).to have_selector("input #search")
  end

  def user_searches_with_a_product_id
    fill_in 'search', with: 'B00PZB5LBM'
  end

  def user_sees_details_for_the_product
    expect(page).to have_text("China Gold Panda")
    expect(page).to have_selector("
  end
end

