require 'rails_helper'

feature 'Author can edit his question', %q(
  In order to supplement a question or correct errors
  As an author of question
  I'd like to be able to edit my question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'tries to edit his question' do
      within '.question' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Update question'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
      end
    end

    scenario 'tires to edit his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update question'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
    scenario 'can add attached files whe edit his question' do
      within '.question' do
        attach_file 'File', [Rails.root / 'spec' / 'rails_helper.rb', Rails.root / 'spec' / 'spec_helper.rb']
        click_on 'Update question'
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end

  scenario 'non author tries to edit the question', js: true do
    sign_in(other_user)
    visit question_path(question)
    expect(page).not_to have_link 'Edit question'
  end
end
