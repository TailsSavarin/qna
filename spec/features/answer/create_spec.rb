require 'rails_helper'

feature 'User can create answer', "
  In order to help another user slove his problem
  As user
  I'd like to be able to create answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'as user', :js do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates answer with valid data' do
      within '.new-answer' do
        fill_in 'Your Answer:', with: 'Test Answer'
        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'Test Answer'
    end

    scenario 'creates answer with invalid data' do
      within '.new-answer' do
        fill_in 'Your Answer:', with: ''
        click_on 'Post Your Answer'
      end

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'as guest' do
    scenario 'can not see create answer link' do
      visit question_path(question)

      expect(page).to_not have_link 'Post Your Answer'
    end
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user page', :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in 'Your Answer:', with: 'Test Answer'
          click_on 'Post Your Answer'
        end

        expect(page).to have_content 'Test Answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Answer'
      end
    end
  end
end
