require 'rails_helper'

feature 'User can delete files from question or answer', %q(
  In order to delete excess or unnecessary files
  As an file's author
  I'd like to be able to delete attached files
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
    question.files.attach(create_file_blob(filename: 'test.jpg'))
    answer.files.attach(create_file_blob(filename: 'test.png'))
  end

  describe 'authenticated user' do
    context 'author', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'deletes attached files from his question' do
        within "#attachment-#{question.files.first.id}" do
          expect(page).to have_content 'test.jpg'

          click_on 'Delete File'
          page.driver.browser.switch_to.alert.accept

          expect(page).to_not have_link 'Delete File'
          expect(page).to_not have_content 'test.jgp'
        end
      end

      scenario 'deletes attached files from his answer' do
        within '.answers' do
          expect(page).to have_content 'test.png'

          click_on 'Delete File'
          page.driver.browser.switch_to.alert.accept

          expect(page).to_not have_link 'Delete File'
          expect(page).to_not have_content 'test.png'
        end
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      scenario 'tries to delete attached files from the question' do
        within '#question' do
          expect(page).to have_content 'test.jpg'
          expect(page).to_not have_link 'Delete File'
        end
      end

      scenario 'tries to delete attached files from the answer' do
        within '.answers' do
          expect(page).to have_content 'test.png'
          expect(page).to_not have_link 'Delete File'
        end
      end
    end
  end

  describe 'unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not delete attached files from the question' do
      within '#question' do
        expect(page).to have_content 'test.jpg'
        expect(page).to_not have_link 'Delete File'
      end
    end

    scenario 'can not delete attached files from the answer' do
      within '.answers' do
        expect(page).to have_content 'test.png'
        expect(page).to_not have_link 'Delete File'
      end
    end
  end
end
