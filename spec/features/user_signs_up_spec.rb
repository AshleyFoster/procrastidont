require 'rails_helper'

RSpec.feature "Signing in" do
  scenario "register redirects user to home" do
    visit '/'
    first(:link, 'Sign up').click

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Phone number', with: '555-555-5555'
    fill_in 'Password', with: 'caplin'
    fill_in 'Password confirmation', with: 'caplin'

    click_button 'Sign up'

    expect(page).to have_content 'Logout'
  end
end
