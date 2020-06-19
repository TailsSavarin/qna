require 'rails_helper'

feature 'User can add link to answer', %q(
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe 'when creates answer, user', js: true do
    background do
      fill_in 'Your Answer:', with: 'text text text'
      fill_in 'Name', with: 'Google'
    end

    scenario 'adds link' do
      fill_in 'URL', with: good_url

      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds bad link' do
      fill_in 'URL', with: bad_url

      click_on 'Post Your Answer'

      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe 'when edits his answer user', js: true do
    background { click_on 'Edit answer' }

    scenario 'adds link' do
      within "#answer-#{answer.id}" do
        click_on 'add link'

        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: good_url

        click_on 'Update answer'

        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds bad link' do
      within "#answer-#{answer.id}" do
        click_on 'add link'

        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: bad_url

        click_on 'Update answer'

        expect(page).to have_content 'Links url is invalid'
      end
    end
  end
end
