require 'rails_helper'

feature 'User can sign out', %q(
  In order to end the session
  As an authenticated user
  I'd like to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_link 'Log out'
    # save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Sign in'
  end
end
