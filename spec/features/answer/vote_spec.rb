require 'rails_helper'

feature 'Authenticated user can vote for the answer that he liked', %q(
  In order to highlight the answer
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up for the answer he like' do
      within '.answers' do
        expect(page).to have_link 'Up'
        click_on 'Up'

        expect(page).to have_content '1'
        expect(page).to_not have_link 'Up'
      end
    end

    scenario 'votes down against the answer' do
      within '.answers' do
        expect(page).to have_link 'Down'
        click_on 'Down'

        expect(page).to have_content '-1'
        expect(page).to_not have_link 'Down'
      end
    end
  end

  scenario 'unauthenticated user can not votes for the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end
end
