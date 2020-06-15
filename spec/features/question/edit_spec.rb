require 'rails_helper'

feature 'Author can edit his question', %q(
  In order to supplement a question or correct errors
  As an author of question
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:other_question) { create(:question) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'and author tries to edit his question' do
      visit question_path(question)
      click_on 'Edit question'
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Update question'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
      end
    end

    scenario 'and author tires to edit his question with errors' do
      visit question_path(question)
      click_on 'Edit'
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update question'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to edit the question' do
      visit question_path(other_question)
      expect(page).not_to have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated user tries to edit the question' do
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end
end
