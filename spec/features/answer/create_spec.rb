require 'rails_helper'

feature 'User can write the answer to the question, on the question page', %q(
  In order to be able to help another user with his decision
  As an authenticated user
  I'd like to be able to write the answer to the question
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes the answer to the question' do
      fill_in 'Your Answer:', with: 'Test Answer'

      click_on 'Post Your Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test Answer'
    end

    scenario 'writes the answer to the question with errors' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'writes the answer to the question and attaches files to it' do
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

  scenario "unauthenticated user can't write the answer to the question" do
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
