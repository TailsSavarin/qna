require 'rails_helper'

feature 'User can register in the system', %q(
  In order to fully use the available functionality
  As an unregistered user
  I'd like to be able to sign up
) do
  background { visit new_user_registration_path }

  scenario 'user tries to sign up' do
    fill_in 'Email', with: 'unregistered_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    open_email('unregistered_user@test.com')

    expect(current_email).to have_content 'Welcome unregistered_user@test.com!'

    current_email.click_link 'Confirm My Account'

    expect(page).to have_content 'Your email address has been successfully confirmed'
  end

  scenario 'user tries to sign up with errors' do
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  describe 'sign in with GitHub' do
    scenario 'user tries to sign in' do
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario 'user handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'
      expect(page).to have_content %(Could not authenticate you from GitHub because "Invalid credentials")
    end
  end

  describe 'sign in with Twitter' do
    scenario 'user tries to sign in' do
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario 'user handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'
      expect(page).to have_content %(Could not authenticate you from Twitter because "Invalid credentials")
    end
  end
end
