require 'rails_helper'

feature 'User can add reward for the new question', %q(
  In order to reward another user for the best answer to your question
  As an question's author
  I'd like to be able to add reward
) do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test text'
  end

  scenario 'user creates question and adds reward' do
    within '#reward' do
      fill_in 'Reward Title', with: 'My Reward'
      attach_file 'Reward Image', Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg'
    end

    click_on 'Create Your Question'

    expect(page).to have_content 'Reward for best Answer active!'
  end

  scenario 'user creates question and adds reward with errors' do
    within '#reward' do
      attach_file 'Reward Image', Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg'
    end

    click_on 'Create Your Question'

    expect(page).to have_content "Reward title can't be blank"
  end
end
