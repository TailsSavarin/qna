require 'rails_helper'

feature 'Author can choose the best answer for his question', %q(
  In order to let see users the best answer'
  As an author of question
  I'd like to be able to choose the best answer for my question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'author tries choose best answer for his question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Select as best'
      expect(page).to have_content 'Best answer'
      expect(page).to_not have_link 'Select as best'
    end
  end

  scenario 'non author tries to choose best answer for question' do
    sign_in(other_user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Select as best'
    end
  end
end