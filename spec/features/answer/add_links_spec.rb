require 'rails_helper'

feature 'User can add links to answer', %q(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:gist_url) { 'https://gist.github.com/TailsSavarin/2d313a9ece10a0c17cb3decee000e294' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  describe 'user creates answer and', js: true do
    background do
      fill_in 'Your Answer:', with: 'Test text'

      click_on 'Add Link'
    end

    scenario 'adds link' do
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link URL', with: good_url

      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds link with errors' do
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link URL', with: bad_url

      click_on 'Post Your Answer'

      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'adds gist link' do
      fill_in 'Link Name', with: 'Gist'
      fill_in 'Link URL', with: gist_url

      click_on 'Post Your Answer'

      expect(page).to have_content 'test-guru-question.txt hosted with ❤ by GitHub'
    end
  end

  describe 'user edits his answer and', js: true do
    background { click_on 'Edit Answer' }

    scenario 'adds link' do
      within "#answer-#{answer.id}" do
        click_on 'Add Link'

        fill_in 'Link Name', with: 'Google'
        fill_in 'Link URL', with: good_url

        click_on 'Update Your Answer'

        expect(page).to have_link 'Google', href: good_url
      end
    end

    scenario 'adds link with errors' do
      within "#answer-#{answer.id}" do
        click_on 'Add Link'

        fill_in 'Name', with: 'Google'
        fill_in 'URL', with: bad_url

        click_on 'Update Your Answer'

        expect(page).to have_content 'Links url is invalid'
      end
    end

    scenario 'adds gist link' do
      within "#answer-#{answer.id}" do
        click_on 'Add Link'

        fill_in 'Name', with: 'Gist'
        fill_in 'URL', with: gist_url

        click_on 'Update Your Answer'
      end

      expect(page).to have_content 'test-guru-question.txt hosted with ❤ by GitHub'
    end
  end
end
