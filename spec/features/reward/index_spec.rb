require 'rails_helper'

feature 'User can watch his rewards', %q(
  In order to get information about his rewards
  As an user
  I'd like to be able to watch watch my rewards
) do
  given(:user) { create(:user) }
  given!(:reward) { create(:reward, user: user) }
  
  scenario 'authenticated user view his rewards' do
    reward.image.attach(create_file_blob(filename: 'test.jpg'))
    sign_in(user)
    visit rewards_path

    expect(page).to have_content 'Your Rewards List'

    expect(page).to have_link reward.question.title
    expect(page).to have_content reward.title
    have_css("img[src*='test.jpg']")
  end

  scenario 'unauthenticated user can not view rewards' do
    visit questions_path

    expect(page).to_not have_link 'My Rewards'
  end
end
