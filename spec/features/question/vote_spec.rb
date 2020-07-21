require 'rails_helper'

feature 'User can vote for the question that he liked', %q(
  In order to highlight the question
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given!(:another_question) { create(:question) }
  given!(:question) { create(:question, user: user) }

  describe 'authenticated user', js: true do
    background { sign_in(user) }

    context 'author' do
      background { visit question_path(question) }

      scenario 'cannot vote for his question' do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    context 'not author' do
      background { visit question_path(another_question) }

      scenario 'votes up for the question' do
        click_on 'Up'

        expect(page).to have_content '1'
        expect(page).to_not have_link 'Up'
      end

      scenario 'vote down for the question' do
        click_on 'Down'

        expect(page).to have_content '-1'
        expect(page).to_not have_link 'Down'
      end

      scenario 're-vote for the question' do
        expect(page).to_not have_link 'Revote'
        click_on 'Up'
        click_on 'Revote'

        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Revote'
      end
    end
  end

  scenario 'unauthenticated user can not vote for the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Up'
    expect(page).to_not have_link 'Down'
  end
end
