require 'rails_helper'

feature 'User can see question with answers', %q(
  In order to find information
  As user
  I'd like to be able to see question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'user sees question with answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'guest sees question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
