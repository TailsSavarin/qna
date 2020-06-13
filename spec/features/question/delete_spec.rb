require 'rails_helper'

feature 'Author can delete his question', %q(
  If cinsider it necessary
  As an author
  I'd like to be able to delete my question
) do
  given(:user) { create(:user) }
  given(:another_question) { create(:question) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user and' do
    background { sign_in(user) }

    scenario 'author of the question tries to delete it' do
      visit question_path(question)
      click_on 'Delete question'
      # save_and_open_page
      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'non author tries to delete the question' do
      visit question_path(another_question)
      # save_and_open_page
      expect(page).not_to have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)
    # save_and_open_page
    expect(page).not_to have_link 'Delete question'
  end
end
