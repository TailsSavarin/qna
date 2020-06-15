require 'rails_helper'

feature 'Author can delete his question', %q(
  If cinsider it necessary
  As an author
  I'd like to be able to delete my question
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'author tries to delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'non author tries to delete the question' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).not_to have_link 'Delete question'
  end
end
