require 'rails_helper'

feature 'Author can delete his question', %q(
  If decide that it's necessary
  As an author
  I'd like to be able to delete my question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    scenario 'author deletes his question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'non author tries to delete the question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete question'
    end
  end

  scenario "unauthenticated user can't delete the question" do
    visit question_path(question)

    expect(page).not_to have_link 'Delete quesiton'
  end
end
