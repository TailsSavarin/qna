require 'rails_helper'

feature 'User being on the question page, can write the answer to the question', %q(
  In order to help another user with a problem
  As an authenticated user
  I'd like to be able to write the answer to the question on question page
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trie to write the answer to the question' do
      fill_in 'Your Answer:', with: 'Test Answer'
      click_on 'Post Your Answer'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test Answer'
    end

    scenario 'trie to write the answer to the question' do
      click_on 'Post Your Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to write the answer with attached files' do
      fill_in 'Your Answer:', with: 'Test Answer'
      attach_file 'File', [Rails.root / 'spec' / 'rails_helper.rb', Rails.root / 'spec' / 'spec_helper.rb']
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'unauthenticated user tries to write the answer to the question' do
    visit question_path(question)
    expect(page).not_to have_link 'Post Your Answer'
  end
end
