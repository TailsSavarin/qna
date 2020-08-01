require 'rails_helper'

feature 'User can add reward for new question', %q(
  In order to reward another user for the best answer
  As an authenticated user
  I'd like to be able to add reward
) do
  given(:user) { create(:user) }
  given(:attach_reward) do
    attach_file 'Reward Image', Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg'
  end

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test text'
  end

  scenario 'user adds reward with valid data' do
    within '#reward' do
      fill_in 'Reward Title', with: 'My Reward'
      attach_reward
    end

    click_on 'Create Your Question'

    expect(page).to have_content 'Reward for best Answer active!'
  end

  scenario 'user adds reward with invalid data' do
    within '#reward' do
      fill_in 'Reward Title', with: ''
      attach_reward
    end

    click_on 'Create Your Question'

    expect(page).to have_content 'Reward title can\'t be blank'
  end
end
