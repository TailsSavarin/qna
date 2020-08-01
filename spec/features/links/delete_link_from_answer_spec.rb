require 'rails_helper'

feature 'User can delete links from answer', %q(
  In order to delete additional information
  As user when create
  As an answer's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'creates answer' do
    it_behaves_like 'link deleting features' do
      given(:linkable_selector) { '.new-answer' }
      given(:linkable_btn) { click_on 'Post Your Answer' }
      given(:background_info) do
        visit question_path(question)
        fill_in 'Your Answer:', with: 'Test text'
      end
    end
  end

  context 'edits answer' do
    it_behaves_like 'link deleting features' do
      given(:linkable_selector) { "#answer-#{answer.id}" }
      given(:linkable_btn) { click_on 'Update Your Answer' }
      given(:background_info) do
        visit question_path(question)
        click_on 'Edit Answer'
      end
    end
  end
end
