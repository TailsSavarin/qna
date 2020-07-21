require 'rails_helper'

feature 'User can sign out', %q(
  In order to end the session
  As an authenticated user
  I'd like to be able to sign out
) do
  given(:user) { create(:user) }

  scenario 'authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(page).to have_content 'Log in'
  end

  scenario 'unauthenticated user can not sign out' do
    expect(page).to_not have_link 'Log out'
  end
end
