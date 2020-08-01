require 'rails_helper'

feature 'User can delete question', %q(
  If decide that it's necessary
  As question's author
  I'd like to be able to delete question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  shared_examples 'can not delete question' do
    scenario 'can not see delete question link' do
      expect(page).to_not have_link 'Delete Question'
    end
  end

  context 'as user' do
    context 'as author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'deletes question' do
        click_on 'Delete Question'

        expect(page).to have_content 'Your question successfully deleted.'
        expect(page).to_not have_content question.title
        expect(current_path).to eq questions_path
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not delete question'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not delete question'
  end
end
