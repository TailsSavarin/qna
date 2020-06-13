require 'rails_helper'

feature 'Author can edit his answer', %q(
  In order to supplement a answer or correct errors
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:other_question) { create(:question) }
  given!(:other_answer) { create(:answer, question: other_question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'and author tries to edit his answer' do
      visit question_path(question)
      # save_and_open_page
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Change answer', with: 'Edited body'
        click_on 'Update answer'
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edited body'
      end
    end

    scenario 'and author tires to edit his answer with errors' do
      visit question_path(question)
      click_on 'Edit answer'
      # save_and_open_page
      within '.answers' do
        fill_in 'Change answer', with: ''
        click_on 'Update answer'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to edit answer' do
      visit question_path(other_question)
      # save_and_open_page
      expect(page).not_to have_link 'Edit answer'
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    # save_and_open_page
    expect(page).not_to have_link 'Edit answer'
  end
end
