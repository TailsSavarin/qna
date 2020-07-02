require 'rails_helper'

feature 'Authenticated user can vote for the answer that he liked', %q(
  In order to highlight the answer
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'author of the answer' do
      scenario 'cannot vote for his anwer' do
        within "#answer-#{answer.id}" do
          expect(page).to_not have_link 'Up'
          expect(page).to_not have_link 'Down'
        end
      end
    end

    context 'not the author of the answer' do
      scenario 'votes up for the answer he like' do
        within "#answer-#{another_answer.id}" do
          expect(page).to have_link 'Up'
          click_on 'Up'

          expect(page).to have_content '1'
          expect(page).to_not have_link 'Up'
        end
      end

      scenario 'votes down against the answer' do
        within "#answer-#{another_answer.id}" do
          expect(page).to have_link 'Down'
          click_on 'Down'

          expect(page).to have_content '-1'
          expect(page).to_not have_link 'Down'
        end
      end

      scenario 'revote the answer' do
        within "#answer-#{another_answer.id}" do
          expect(page).to_not have_link 'Revote'
          click_on 'Up'
          expect(page).to have_link 'Revote'
          click_on 'Revote'

          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'
          expect(page).to_not have_link 'Revote'
        end
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
