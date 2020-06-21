require 'rails_helper'

feature 'Author can edit his question', %q(
  In order to supplement a question or correct errors
  As an author
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    context 'as an author', js: true do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit Question'
      end

      scenario 'edits his question' do
        within '.question' do
          fill_in 'Title', with: 'Edited title'
          fill_in 'Body', with: 'Edited body'
          click_on 'Update Your Question'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to_not have_selector 'textarea'
          expect(page).to have_content 'Edited title'
          expect(page).to have_content 'Edited body'
        end
      end

      scenario 'edits his question with errors' do
        within '.question' do
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Update Your Question'

          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'adds attached files while edit his question' do
        within '.question' do
          attach_file 'File', [
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
          ]

          click_on 'Update Your Question'

          expect(page).to have_content 'test.jpg'
          expect(page).to have_content 'test.png'
        end
      end
    end

    scenario 'non author tries to edit the question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_link 'Edit Question'
    end
  end

  scenario "unauthenticated user can't edit the question" do
    visit question_path(question)

    expect(page).not_to have_link 'Edit Question'
  end
end
