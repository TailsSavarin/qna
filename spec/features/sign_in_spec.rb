require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered or with invalid data, user tries to sign in' do
    fill_in 'Email', with: 'unregistered@test.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'user tries to sign in with Github account' do
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'user handle authentication error' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    click_on 'Sign in with GitHub'
    expect(page).to have_content %(Could not authenticate you from GitHub because "Invalid credentials")
  end
end
