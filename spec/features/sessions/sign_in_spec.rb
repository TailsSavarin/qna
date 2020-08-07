require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As user
  I'd like to be able to sign in
) do
  given(:confirmed_user) { create(:user) }
  given(:unconfirmed_user) { create(:user, confirmed_at: '') }

  background { visit new_user_session_path }

  context 'registered user signs in' do
    scenario 'with confirmed email' do
      within '.card-body' do
        fill_in 'Email', with: confirmed_user.email
        fill_in 'Password', with: confirmed_user.password
        click_on 'Log in'
      end

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'with unconfirmed email' do
      within '.card-body' do
        fill_in 'Email', with: unconfirmed_user.email
        fill_in 'Password', with: unconfirmed_user.password
        click_on 'Log in'
      end

      expect(page).to have_content 'You have to confirm your email address before continuing.'
      expect(current_path).to eq new_user_session_path
    end
  end

  scenario 'non-registered user try to sign in' do
    within '.card-body' do
      fill_in 'Email', with: 'unregistered@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'
    end

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  context 'sign in with GitHub' do
    it_behaves_like 'sign in features' do
      given(:mock_auth) { mock_auth_github }
      given(:social_network) { 'GitHub' }
      given(:mock_auth_invalid) do
        OmniAuth.config.mock_auth[:github] = :invalid_credentials
      end
    end
  end

  context 'sign in with Facebook' do
    it_behaves_like 'sign in features' do
      given(:mock_auth) { mock_auth_facebook }
      given(:social_network) { 'Facebook' }
      given(:mock_auth_invalid) do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      end
    end
  end
end
