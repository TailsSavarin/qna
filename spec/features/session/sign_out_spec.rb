require 'rails_helper'

feature 'User can sign out', "
  In order to end the session
  As user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'signed in user try to sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
