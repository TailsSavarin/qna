require 'rails_helper'

feature 'add files to question', :js do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'creates question' do
    it_behaves_like 'files features' do
      given(:filable_selector) { '#files' }
      given(:filable_btn) { click_on 'Create Your Question' }
      given(:background_info) do
        visit new_question_path
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
      end
    end
  end

  context 'edits question' do
    it_behaves_like 'files features' do
      given(:filable_selector) { '#edit-question' }
      given(:filable_btn) { click_on 'Update Your Question' }
      given(:background_info) do
        visit question_path(question)
        click_on 'Edit Question'
      end
    end
  end
end
