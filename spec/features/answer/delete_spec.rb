require 'rails_helper'

feature 'User can delete answer', %q(
  If decide that it's necessary
  As an answer's author
  I'd like to be able to delete answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples 'cannot delete answer' do
    scenario 'cannot see delete link' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Delete Answer'
      end
    end
  end

  context 'as user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'as author', :js do
      scenario 'delete answer' do
        within "#answer-#{answer.id}" do
          click_on 'Delete Answer'
        end

        page.driver.browser.switch_to.alert.accept

        expect(page).to_not have_content answer.body
      end
    end

    context 'non-author' do
      given(:answer) { create(:answer, question: question) }

      it_behaves_like 'cannot delete answer'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'cannot delete answer'
  end
end
