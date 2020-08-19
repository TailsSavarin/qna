require 'rails_helper'

feature 'User can add comments to answer', "
  In order to discuss
  As user
  I'd like to be able to add comments
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  it_behaves_like 'comments adding features' do
    given(:commentable_selector) { "#answer-#{answer.id}-comments" }
    given(:add_comment) { '.answer-add-comment-link' }
  end

  context 'multiple sessions' do
    scenario 'answer comment appears on another user page', :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          click_on 'Add a comment'
          fill_in :comment_body, with: 'Test comment'
          click_on 'Post Your Comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
