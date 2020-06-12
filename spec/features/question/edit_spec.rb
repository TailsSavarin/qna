require 'rails_helper'

feature 'Author can edit his question', %q(
  In order to supplement a question or correct errors
  As an author of answer
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'and author tries to edit his question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      # save_and_open_page
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Update Question'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
      end
    end
    scenario 'and author tires to edit his question with errors'
    scenario 'tries to edit question'
  end

  scenario 'Unauthenticated user can not edit question'
end
