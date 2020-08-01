require 'rails_helper'

feature 'User can create question', %q(
  In order to get an answer to it
  As user
  I'd like to be able to create a question
) do
  given(:user) { create(:user) }

  context 'as user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask Question'
    end

    scenario 'creates question with valid data' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text'
      click_on 'Create Your Question'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test text'
    end

    scenario 'creates question with invalid data' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Create Your Question'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'as guest' do
    background { visit questions_path }

    scenario 'can not create question' do
      click_on 'Ask Question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'multiple sessions' do
    scenario 'question appears on another user page', :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask Question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text'
        click_on 'Create Your Question'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text'
      end
    end
  end
end
