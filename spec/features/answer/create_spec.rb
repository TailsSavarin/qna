require 'rails_helper'

feature 'User being on the question page, can write the answer to the question', %q(
  In order to help another user with a problem
  As an authenticated user
  I'd like to be able to write the answer to the question on question page
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trie to write the answer to the question on question page' do
      fill_in 'Body', with: 'Test Answer'
      click_on 'Create Answer'
      # save_and_open_page
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Test Answer'
    end

    scenario 'User trie to write the answer to the question on question page with errors' do
      click_on 'Create Answer'
      # save_and_open_page
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write the answer to the question on question page' do
    visit question_path(question)
    click_on 'Create Answer'
    # save_and_open_page
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
