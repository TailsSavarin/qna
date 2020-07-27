require 'rails_helper'

feature 'User can subscribe for the question', %q(
  In order to receive notifications about new answers
  As an authenticated user
  I'd like to be able to subscribe
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user tries to subscribe to the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to_not have_link 'Subscribe'
  end

  scenario 'unauthenticated can not subscribe to the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end
end

