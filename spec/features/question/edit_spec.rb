require 'rails_helper'

feature 'User can edit question', "
  In order to correct mistakes
  As question's author
  I'd like to be able to make changes
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  shared_examples 'can not edit question' do
    scenario 'can not see edit question link' do
      expect(page).to_not have_link 'Edit Question'
    end
  end

  context 'as user' do
    context 'as author', :js do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit Question'
      end

      scenario 'updates question with valid data' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Update Your Question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body

        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
      end

      scenario 'updates question with invalid data' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update Your Question'

        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not edit question'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not edit question'
  end
end
