require 'rails_helper'

feature 'add files to answer', :js do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'creates answer' do
    it_behaves_like 'file adding features' do
      given(:file_selector) { '.new-answer' }
      given(:file_btn) { click_on 'Post Your Answer' }
      given(:background_info) do
        visit question_path(question)
        fill_in 'Your Answer:', with: 'Test text'
      end
    end
  end

  context 'edits answer' do
    it_behaves_like 'file adding features' do
      given(:file_selector) { "#answer-#{answer.id}" }
      given(:file_btn) { click_on 'Update Your Answer' }
      given(:background_info) do
        visit question_path(question)
        click_on 'Edit Answer'
      end
    end
  end
end
