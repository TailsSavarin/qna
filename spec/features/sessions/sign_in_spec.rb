require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As an authenticated user
  I'd like to be able to sign in
) do
  given(:confirmed_user) { create(:user) }
  given(:unconfirmed_user) { create(:user, confirmed_at: '') }
  background { visit new_user_session_path }

  describe 'registered user tries to sign in' do
    scenario 'with confirmed email' do
      within '.card-body' do
        fill_in 'Email', with: confirmed_user.email
        fill_in 'Password', with: confirmed_user.password
        click_on 'Log in'
      end

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'with unconfirmed email' do
      within '.card-body' do
        fill_in 'Email', with: unconfirmed_user.email
        fill_in 'Password', with: unconfirmed_user.password
        click_on 'Log in'
      end

      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end
  end

  scenario 'unregistered or with invalid data, user tries to sign in' do
    within '.card-body' do
      fill_in 'Email', with: 'unregistered@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
    end

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'sign in with GitHub' do
    scenario 'user tries to sign in' do
      mock_auth_github
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
      mock_auth_twitter
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    scenario 'user handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      click_on 'Sign in with Twitter'

      expect(page).to have_content %(Could not authenticate you from Twitter because "Invalid credentials")
    end
  end

  describe 'sign in with Facebook' do
    scenario 'user tries to sign in' do
      mock_auth_facebook
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    scenario 'user handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'

      expect(page).to have_content %(Could not authenticate you from Facebook because "Invalid credentials")
    end
  end
end
