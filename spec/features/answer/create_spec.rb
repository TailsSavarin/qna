require 'rails_helper'

feature 'User being on the question page, can write the answer to the question', %q(
  In order to help another user with a problem
  As an user
  I'd like to be able to write the answer to the question on question page
) do
  given!(:question) { create(:question) }
  background { visit question_path(question) }

  scenario 'User trie to write the answer to the question on question page' do
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
