require 'rails_helper'

feature 'User can choose best answer', "
  In order to highlight it
  As question's author
  I'd like to be able to choose best answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  shared_examples 'can not choose best answer' do
    scenario 'can not see select as best link' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Select as best'
      end
    end
  end

  context 'as user' do
    context 'as question author', :js do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'chooses best answer' do
        within "#answer-#{answer.id}" do
          click_on 'Select as best'
        end

        within '.answers' do
          expect(page).to have_content 'Best Answer'
          expect(page).to_not have_link 'Select as best'
        end
      end
    end

    context 'non-owner' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not choose best answer'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not choose best answer'
  end
end
