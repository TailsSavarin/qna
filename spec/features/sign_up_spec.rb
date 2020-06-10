require 'rails_helper'

feature 'User can register in the system', %q(
  In order to fully use the available functionality
  As an unregistered user
  I'd like to be able to sign up
) do
  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'unregistered_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with errors' do
    click_button 'Sign up'
    # save_and_open_page
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
