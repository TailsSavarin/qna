require 'rails_helper'

feature 'User being on the question page, can write the answer to the question', %q(
  In order to help another user with a problem
  As an authenticated user
  I'd like to be able to write the answer to the question on question page
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trie to write the answer to the question on question page' do
      fill_in 'Your answer:', with: 'Test Answer'
      click_on 'Add answer'
      # save_and_open_page
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test Answer'
    end

    scenario 'trie to write the answer to the question on question page with errors' do
      click_on 'Add answer'
      # save_and_open_page
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write the answer to the question on question page' do
    visit question_path(question)
    # save_and_open_page
    expect(page).not_to have_link 'Add answer'
  end
end
