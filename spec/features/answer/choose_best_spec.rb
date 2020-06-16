require 'rails_helper'

feature 'Author can choose the best answer to his question', %q(
  In order for other users to be informed'
  As an author of the question
  I'd like to be able to choose the best answer for my question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user' do
    scenario 'author chooses the best answer to his question', js: true do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Select as best'

        expect(page).to have_content 'Best answer'
        expect(page).to_not have_link 'Select as best'
      end
    end

    scenario 'non author trying to choose the best answer to the question' do
      sign_in(other_user)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Select as best'
      end
    end
  end

  scenario "unauthenticated user can't choose the best answer to the question" do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Select as best'
    end
  end
end
