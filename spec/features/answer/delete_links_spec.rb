require 'rails_helper'

feature 'User can delete link from the answer', %q(
  In order to remove unnecessary or excess links
  As an answer's author
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

  scenario 'user creates answer and deletes link', js: true do
    within '.new-answer' do
      click_on 'Add Link'

      expect(page).to have_content 'Link Name'
      expect(page).to have_content 'Link URL'

      click_on 'Remove Link'
      page.driver.browser.switch_to.alert.accept

      expect(page).to_not have_content 'Link Name'
      expect(page).to_not have_content 'Link URL'
      expect(page).to_not have_link 'Remove Link'
    end

    expect(page).to_not have_link 'Yandex', href: url
  end

  scenario 'author edits answer and deletes link', js: true do
    expect(page).to have_link link.name, href: link.url

    click_on 'Edit Answer'

    within "#answer-#{answer.id}" do
      click_on 'Remove Link'
      page.driver.browser.switch_to.alert.accept

      click_on 'Update Your Answer'
    end

    expect(page).to_not have_link link.name, href: link.url
  end
end
