require "rails_helper"

feature 'Searching for a product' do
  scenario 'User loads the application' do
    When 'user visits homepage'
    Then 'user sees application'
  end
  def user_visits_homepage
    visit root_path
  end

  def user_sees_application
    expect(page).to have_text("Pricegrid")
    expect(page).to have_text("See color and size combinations for Amazon products")
  end
end

