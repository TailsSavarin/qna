require 'rails_helper'

feature 'User can watch the question and answers to it', %q(
  In order to get the information that interests him
  As an user
  I'd like to be able to watch the question and answers to it
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Authenticated user trie to watch the question and answers to it' do
    sign_in(user)
    visit question_path(question)
    # save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user trie to watch the question and answers to it' do
    visit question_path(question)
    # save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
