require 'rails_helper'

feature 'User can add links to question', "
  In order to add additional information
  As user when create
  As an question's author when edit
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'creates question' do
    it_behaves_like 'link adding features' do
      given(:linkable_selector) { '#links' }
      given(:linkable_btn) { click_on 'Create Your Question' }
      given(:background_info) do
        visit new_question_path
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text'
      end
    end
  end

  context 'edits question' do
    it_behaves_like 'link adding features' do
      given(:linkable_selector) { '#edit-question' }
      given(:linkable_btn) { click_on 'Update Your Question' }
      given(:background_info) do
        visit question_path(question)
        click_on 'Edit Question'
      end
    end
  end
end
