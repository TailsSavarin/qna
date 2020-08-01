require 'rails_helper'

feature 'User can add links to question', %q(
  In order to add additional information
  As an authenticated user when create
  As an question's author when edit
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'creates question' do
    it_behaves_like 'links features' do
      given(:linkable_selector) { '#links' }
      given(:linkable_btn) { click_on 'Create Your Question' }
      given(:background_i) do
        visit new_question_path
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text'
      end
    end
  end

  context 'edits question' do
    it_behaves_like 'links features' do
      given(:linkable_selector) { '#edit-question' }
      given(:linkable_btn) { click_on 'Update Your Question' }
      given(:background_i) do
        visit question_path(question)
        click_on 'Edit Question'
      end
    end
  end
end
