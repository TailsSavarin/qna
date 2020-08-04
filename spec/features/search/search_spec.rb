require 'sphinx_helper'

feature 'User can use search', %q(
  In order to find information he needs
  As guest
  I'd like to be able to use search
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question) }

  background { visit root_path }

  scenario 'user searchs All', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: ''
      click_on 'Search'

      expect(page).to have_content user.email
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content question_comment.body
    end
  end

  scenario 'user searchs Question' do
    ThinkingSphinx::Test.run do
      select 'Question', from: :resource
      fill_in 'Search', with: question.title
      click_on 'Search'

      expect(page).to have_content question.title
      within '.container' do
        %w[Answer Comment User].each do |resource|
          expect(page).to_not have_content resource
        end
      end
    end
  end

  scenario 'user searchs Answer' do
    ThinkingSphinx::Test.run do
      select 'Answer', from: :resource
      fill_in 'Search', with: answer.body
      click_on 'Search'

      expect(page).to have_content answer.body
      within '.container' do
        %w[Question Comment User].each do |resource|
          expect(page).to_not have_content resource
        end
      end
    end
  end

  scenario 'user searchs Comment' do
    ThinkingSphinx::Test.run do
      select 'Comment', from: :resource
      fill_in 'Search', with: question_comment.body
      click_on 'Search'

      save_and_open_page
      expect(page).to have_content question_comment.body
      within '.container' do
        %w[Question User].each do |resource|
          expect(page).to_not have_content resource
        end
      end
    end
  end

  scenario 'user searchs Comment' do
    ThinkingSphinx::Test.run do
      select 'User', from: :resource
      fill_in 'Search', with: user.email
      click_on 'Search'

      expect(page).to have_content user.email
      within '.container' do
        %w[Question Answer Comment].each do |resource|
          expect(page).to_not have_content resource
        end
      end
    end
  end
end
