require 'rails_helper'

feature 'Author can edit his question', %q(
  In order to supplement a question or correct errors
  As an author of answer
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

    scenario 'and author tires to edit his question with errors' do
      visit question_path(question)
      click_on 'Edit'
      # save_and_open_page
      within '.question' do
        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        click_on 'Update Question'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to edit question' do
      visit question_path(other_question)
      # save_and_open_page
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    # save_and_open_page
    expect(page).not_to have_link 'Edit'
  end
end
