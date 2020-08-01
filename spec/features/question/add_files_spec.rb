require 'rails_helper'

feature 'add files to answer', :js do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  context 'edit question' do
    background do
      within '#question' do
        click_on 'Edit Answer'
      end
    end

    scenario 'add files' do
      within '#edit-question' do
        attach_file 'File', [
          Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
          Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
        ]
        click_on 'Update Your Question'
      end

      expect(page).to have_content 'test.jpg'
      expect(page).to have_content 'test.png'
    end
  end

  context 'create question' do
    scenario 'add files' do
      fill_in 'Your Answer:', with: 'Test Answer'
      attach_file 'File', [
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
      ]
      click_on 'Post Your Answer'

      expect(page).to have_link 'test.jpg'
      expect(page).to have_link 'test.png'
    end
  end
end
