require 'rails_helper'

feature 'User can unsubscribe from the question', %q(
  In order to not receive notifications about new answers
  As an authenticated user
  I'd like to be able to unsubscribe
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'authenticated user tries to unsubscribe from the question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Unsubscribe'

    expect(page).to_not have_link 'Unsubscribe'
  end

  scenario 'unauthenticated can not unsubscribe from the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Unsubscribe'
  end
end
