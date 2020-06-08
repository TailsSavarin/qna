require 'rails_helper'

feature 'User can watch all the questions', %q(
  In order to find the right question
  As an user
  I'd like to be able to watch all the questions
) do
  given!(:questions) { create_list(:question, 5) }

  scenario 'User tries to watch all the questions' do
    visit questions_path

    expect(page).to have_content 'Questions List'
    questions.each { |question| expect(page).to have_content question.title }
  end
end
