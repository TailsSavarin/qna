require 'rails_helper'

feature 'User can edit answer', %q(
  In order to make changes
  As an answer's author
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples 'cannot edit answer' do
    scenario 'cannot see edit link' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link('Edit Answer')
      end
    end
  end

  context 'as user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'as author', :js do
      background do
        within "#answer-#{answer.id}" do
          click_on 'Edit Answer'
        end
      end

      scenario 'updates answer' do
        within "#edit-answer-#{answer.id}" do
          fill_in 'Change Answer', with: 'Edited body'
          click_on 'Update Your Answer'
        end

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited body'
      end

      scenario 'invalid answer data' do
        within "#edit-answer-#{answer.id}" do
          fill_in 'Change Answer', with: ''
          click_on 'Update Your Answer'
        end

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    context 'non-author' do
      given(:answer) { create(:answer, question: question) }

      it_behaves_like 'cannot edit answer'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'cannot edit answer'
  end
end
