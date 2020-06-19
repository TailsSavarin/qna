require 'rails_helper'

feature 'User can add link to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:test_url) { 'https://www.google.com' }

  scenario 'User adds links when asks question' do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Name', with: 'Google'
    fill_in 'URL', with: test_url

    click_on 'Create question'

    expect(page).to have_link 'Google', href: test_url
  end
end
