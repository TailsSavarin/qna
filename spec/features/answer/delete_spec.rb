require 'rails_helper'

feature 'Author can delete his answer', %q(
  If cinsider it necessary
  As an author
  I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:answer) { create(:answer, user: user) }

  describe 'Authenticated user and' do
    scenario 'author of the answer tries to delete it' do
      sign_in(user)
      visit question_path(answer.question)
      click_on 'Delete Answer'
      # save_and_open_page
      expect(page).to have_content 'Your answer successfully deleted.'
      expect(page).not_to have_content(answer.body)
    end

    scenario 'non author tries to delete the answer' do
      sign_in(another_user)
      visit question_path(answer.question)
      # save_and_open_page
      expect(page).not_to have_link 'Delete Answer'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(answer.question)
    # save_and_open_page
    expect(page).not_to have_link 'Delete Answer'
  end
end
