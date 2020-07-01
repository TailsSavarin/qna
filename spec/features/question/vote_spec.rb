require 'rails_helper'

feature 'Authenticated user can vote for the question that he liked', %q(
  In order to highlight the answer
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up for the question he like' do
      expect(page).to have_link 'Up'
      click_on 'Up'

      expect(page).to have_content 'Question rating: 1'
      expect(page).to_not have_link 'Up'
    end

    scenario 'votes down against the question' do
      expect(page).to have_link 'Down'
      click_on 'Down'

      expect(page).to have_content 'Question rating: -1'
      expect(page).to_not have_link 'Down'
    end
  end

  scenario 'unauthenticated user can not votes for the question' do
    visit questions_path

    expect(page).to_not have_link 'Up'
    expect(page).to_not have_link 'Down'
  end
end
