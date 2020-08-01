require 'rails_helper'

feature 'User can delete links from question', %q(
  In order to delete additional information
  As user when create
  As an question's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'creates question' do
    it_behaves_like 'link deleting features' do
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
    it_behaves_like 'link deleting features' do
      given(:linkable_selector) { '#edit-question' }
      given(:linkable_btn) { click_on 'Update Your Question' }
      given(:background_info) do
        visit question_path(question)
        click_on 'Edit Question'
      end
    end
  end
end
