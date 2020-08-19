require 'rails_helper'

feature 'User can delete answer', "
  If decide that it's necessary
  As answer's author
  I'd like to be able to delete answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples 'can not delete answer' do
    scenario 'can not see delete answer link' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Delete Answer'
      end
    end
  end

  context 'as user' do
    context 'as author', :js do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'deletes answer' do
        within "#answer-#{answer.id}" do
          click_on 'Delete Answer'
          page.driver.browser.switch_to.alert.accept
        end

        expect(page).to_not have_content answer.body
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not delete answer'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not delete answer'
  end
end
