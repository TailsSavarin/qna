require 'rails_helper'

feature 'User can write the answer to the question', %q(
  In order to help another user with his problem
  As an authenticated user
  I'd like to be able to write the answer
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes the answer' do
      fill_in 'Your Answer:', with: 'Test Answer'

      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test Answer'
    end

    scenario 'writes the answer with attached files' do
      fill_in 'Your Answer:', with: 'Test Answer'

      attach_file 'File', [
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
        Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
      ]

      click_on 'Post Your Answer'

      expect(page).to have_link 'test.jpg'
      expect(page).to have_link 'test.png'
    end

    scenario 'writes the answer with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unauthenticated user can not write the answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Post Your Answer'
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user page', js: true do
      Capybara.using_session('authenticated_user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('unauthenticated_user') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated_user') do
        fill_in 'Your Answer:', with: 'Test Answer'

        click_on 'Post Your Answer'

        within '.answers' do
          expect(page).to have_content 'Test Answer'
        end
      end

      Capybara.using_session('unauthenticated_user') do
        expect(page).to have_content 'Test Answer'
      end
    end
  end
end
