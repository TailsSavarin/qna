require 'rails_helper'

feature 'User can add link to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:test_url) { 'https://www.google.com' }
  given(:question) { create(:question, user: user) }

  background { sign_in(user) }

  scenario 'User adds links when create question' do
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'Google'
    fill_in 'URL', with: test_url

    click_on 'Create question'

    expect(page).to have_link 'Google', href: test_url
  end

  scenario 'User adds links when edits his question', js: true do
    visit question_path(question)
    click_on 'Edit question'
    click_on 'add link'

    fill_in 'Name', with: 'Google'
    fill_in 'URL', with: test_url

    click_on 'Update question'

    expect(page).to have_link 'Google', href: test_url
  end
end
