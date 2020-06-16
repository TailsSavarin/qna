require 'rails_helper'

feature 'Author can edit his answer', %q(
  In order to supplement a answer or correct errors
  As an author
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    context 'as an author', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'edits his answer' do
        within '.answers' do
          click_on 'Edit answer'
          fill_in 'Change answer', with: 'Edited body'
          click_on 'Update answer'

          expect(page).to_not have_content answer.body
          expect(page).to_not have_selector 'textarea'
          expect(page).to have_content 'Edited body'
        end
      end

      scenario 'edits his answer with errors' do
        within '.answers' do
          click_on 'Edit answer'
          fill_in 'Change answer', with: ''
          click_on 'Update answer'

          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'adds attached files while edit his answer' do
        within '.answers' do
          click_on 'Edit answer'
          attach_file 'File', [
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
          ]
          click_on 'Update answer'

          expect(page).to have_content 'test.jpg'
          expect(page).to have_content 'test.png'
        end
      end
    end

    scenario 'non author tries to edit the answer' do
      sign_in(other_user)
      visit question_path(question)
      within '.answers' do
        expect(page).not_to have_link 'Edit answer'
      end
    end
  end

  scenario "unauthenticated user can't edit the answer" do
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_link 'Edit answer'
    end
  end
end
