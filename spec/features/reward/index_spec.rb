require 'rails_helper'

feature 'User can watch his rewards', %q(
  In order to get information about his rewards
  As an user
  I'd like to be able to watch watch my rewards
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:rewards) { create_list(:reward, 5, user: user) }

  scenario 'authenticated user view his rewards' do
    sign_in(user)

    visit question_path(question)

    click_on 'My rewards'

    expect(page).to have_content 'Your Rewards List'
  end

  scenario 'unauthenticated user can not view rewards' do
    visit question_path(question)

    expect(page).to_not have_link 'My rewards'
  end
end
