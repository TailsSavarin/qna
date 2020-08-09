require 'rails_helper'

feature 'User can see rewards', %q(
  In order to get information about rewards
  As an reward's owner
  I'd like to be able to see rewards
) do
  given(:user) { create(:user) }
  given!(:reward) { create(:reward, user: user) }

  scenario 'user sees rewards' do
    reward.image.attach(create_file_blob(filename: 'test.jpg'))
    sign_in(user)
    visit rewards_path

    expect(page).to have_content 'Your Reward List'
    expect(page).to have_link reward.question.title
    expect(page).to have_content reward.title
    have_css("img[src*='test.jpg']")
  end

  scenario 'guest can not see reward link' do
    visit questions_path

    expect(page).to_not have_link 'My Rewards'
  end
end
