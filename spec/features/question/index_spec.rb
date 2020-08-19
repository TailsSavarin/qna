require 'rails_helper'

feature 'User can see list of questions', "
  In order to look for questions
  As user
  I'd like to be able to see all questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }

  scenario 'user sees list of questions' do
    sign_in(user)
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario 'guest sees list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
