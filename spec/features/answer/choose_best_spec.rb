require 'rails_helper'

feature 'User can choose the best answer to his question', %q(
  In order for other users to be informed and find best solution
  As an question's author
  I'd like to be able to choose the best answer for my question
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user' do
    scenario 'author chooses the best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Select as best'

        expect(page).to have_content 'Best Answer'
        expect(page).to_not have_link 'Select as best'
      end
    end

    scenario 'not author tries to choose the best answer' do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Select as best'
      end
    end
  end

  scenario 'unauthenticated user can not choose the best answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Select as best'
    end
  end
end
