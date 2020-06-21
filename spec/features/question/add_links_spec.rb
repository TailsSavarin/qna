require 'rails_helper'

feature 'User can add link to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/TailsSavarin/2d313a9ece10a0c17cb3decee000e294' }

  background { sign_in(user) }

  describe 'user creates question and', js: true do
    background do
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'
    end

    scenario 'adds link' do
      within '#links' do
        click_on 'Add Link'
        fill_in 'Link Name', with: 'Google'
        fill_in 'Link URL', with: good_url
      end

      click_on 'Create Your Question'

      within '.question-links' do
        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds bad link' do
      within '#links' do
        click_on 'Add Link'
        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: bad_url
      end

      click_on 'Create Your Question'

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'adds gist link' do
      within '#links' do
        click_on 'Add Link'
        fill_in 'Name', with: 'Gist'
        fill_in 'URL', with: gist_url
      end

      click_on 'Create Your Question'

      within '.gist' do
        expect(page).to have_content 'test-guru-question.txt hosted with ❤ by GitHub'
      end
    end
  end

  describe 'author edits question and', js: true do
    background do
      visit question_path(question)
      click_on 'Edit Question'
    end

    scenario 'adds link' do
      within '#edit-question' do
        click_on 'Add Link'
        fill_in 'Link Name', with: 'Google'
        fill_in 'Link URL', with: good_url

        click_on 'Update Your Question'
      end

      within '.question-links' do
        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds bad link' do
      within '#edit-question' do
        click_on 'Add Link'
        fill_in 'Link Name', with: 'Google'
        fill_in 'Link URL', with: bad_url

        click_on 'Update Your Question'
      end

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'adds gist link' do
      within '#edit-question' do
        click_on 'Add Link'
        fill_in 'Link Name', with: 'Gist'
        fill_in 'Link URL', with: gist_url

        click_on 'Update Your Question'
      end

      within '.gist' do
        expect(page).to have_content 'test-guru-question.txt hosted with ❤ by GitHub'
      end
    end
  end
end
