require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As an user
  I'd like to be able to create a question
) do
  background do
    visit questions_path
    click_on 'Create question'
  end

  scenario 'User create a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'
    # save_and_open_page
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'User create a question with errors' do
    click_on 'Ask'
    # save_and_open_page
    expect(page).to have_content "Title can't be blank"
  end
end
