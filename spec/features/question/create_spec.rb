require 'rails_helper'

feature 'User can create the question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create a question
) do
  given(:user) { create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask Question'
    end

    scenario 'creates a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'Create Your Question'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'creates question with errors' do
      click_on 'Create Your Question'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', [
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
      ]

      click_on 'Create Your Question'

      expect(page).to have_link 'test.jpg'
      expect(page).to have_link 'test.png'
    end
  end

  scenario 'unauthenticated user tries to ask a question' do
    visit questions_path

    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
