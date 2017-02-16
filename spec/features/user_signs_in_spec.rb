require 'rails_helper'

RSpec.feature "Login" do
  scenario "register redirects user to home" do
    user = create(:user, password: 'password')

    visit '/'
    click_on 'Login'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'

    click_button 'Log in'

    expect(page).to have_content 'Logged in as'
  end
end
