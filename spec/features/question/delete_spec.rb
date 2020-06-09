require 'rails_helper'

feature 'Author can delete his question', %q(
  If cinsider it necessary
  As an author
  I'd like to be able to delete my question
) do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  given(:question1) { create(:question, author: user1) }
  given(:question2) { create(:question, author: user2) }

  describe 'Authenticated user and' do
    background { sign_in(user1) }

    scenario 'author of the question tries to delete it' do
      visit question_path(question1)
      click_on 'Delete'
      # save_and_open_page
      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'non author tries to delete the question' do
      visit question_path(question2)
      click_on 'Delete'
      # save_and_open_page
      expect(page).to have_content "You don't have sufficient rights to delete this question."
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question1)
    click_on 'Delete'
    # save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
