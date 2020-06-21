require 'rails_helper'

feature 'User can delete link from question', %q(
  In order to remove unnecessary links from my question
  As an question's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:url) { 'https://www.yandex.ru' }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, :for_question, linkable: question) }

  background { sign_in(user) }

  scenario 'when creates question, user deletes link', js: true do
    visit new_question_path

    within '.title' do
      fill_in 'Title', with: 'Test question'
    end

    within '.body' do
      fill_in 'Body', with: 'text text text'
    end

    within '#links' do
      fill_in 'Name', with: 'Yandex'
      fill_in 'URL', with: url

      click_on 'remove link'
    end

    click_on 'Create Question'

    expect(page).to_not have_link 'Yandex', href: url
  end

  scenario 'when edits his question, user deletes link', js: true do
    visit question_path(question)

    click_on 'Edit Question'

    within '#edit-question' do
      click_on 'remove link'

      click_on 'Update Question'
    end

    expect(page).to_not have_content link
  end
end
