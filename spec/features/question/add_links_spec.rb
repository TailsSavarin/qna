require 'rails_helper'

feature 'User can add link to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given(:question) { create(:question, user: user) }

  background { sign_in(user) }

  describe 'when creates question, user', js: true do
    scenario 'adds link' do
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: good_url

      click_on 'Create question'

      expect(page).to have_link 'Google', href: good_url
    end

    scenario 'adds bad link' do
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: bad_url

      click_on 'Create question'

      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe 'when edits his question, user', js: true do
    background do
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'adds link' do
      within '#edit-question' do
        click_on 'add link'

        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: good_url

        click_on 'Update question'
      end

      expect(page).to have_link 'Google', href: good_url
    end

    scenario 'adds bad link' do
      within '#edit-question' do
        click_on 'add link'

        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: bad_url

        click_on 'Update question'
      end

      expect(page).to have_content 'Links url is invalid'
    end
  end
end
