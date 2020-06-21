require 'rails_helper'

feature 'User can delete link from the question', %q(
  In order to remove unnecessary or excess links from my question
  As an question's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:url) { 'https://www.yandex.ru' }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, :for_question, linkable: question) }

  background { sign_in(user) }

  scenario 'user creates question and deletes excess link', js: true do
    visit new_question_path

    click_on 'Add Link'

    expect(page).to have_content 'Link Name'
    expect(page).to have_content 'Link URL'

    click_on 'Remove Link'
    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_content 'Link Name'
    expect(page).to_not have_content 'Link URL'
    expect(page).to_not have_link 'Remove Link'
  end

  scenario 'user edits question and deletes excess link', js: true do
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url

    click_on 'Edit Question'

    within '#edit-question' do
      click_on 'Remove Link'
      page.driver.browser.switch_to.alert.accept

      click_on 'Update Your Question'
    end

    expect(page).to_not have_link link.name, href: link.url
  end
end
