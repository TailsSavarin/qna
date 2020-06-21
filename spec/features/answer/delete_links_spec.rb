require 'rails_helper'

feature 'User can delete link from answer', %q(
  In order to provide additional info to my answer
  As an answers's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:url) { 'https://www.yandex.ru' }
  given!(:link) { create(:link, :for_answer, linkable: answer) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user deletes link, when create an answer', js: true do
    within '.new-answer' do
      fill_in 'Your Answer:', with: 'text text text'
      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: url

      click_on 'remove link'

      click_on 'Post Your Answer'
    end

    expect(page).to_not have_link 'Yandex', href: url
  end

  scenario 'when edits his answer user deletes link', js: true do
    click_on 'Edit Answer'

    within "#answer-#{answer.id}" do
      click_on 'remove link'

      click_on 'Update Answer'
    end

    expect(page).to_not have_content link
  end
end
