require 'rails_helper'

feature 'User can register in the system', %q(
  In order to fully use the available functionality
  As an unregistered user
  I'd like to be able to sign up
) do
  background { visit new_user_registration_path }

  scenario 'user tries to sign up' do
    within '.card-body' do
      fill_in 'Email', with: 'unregistered_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'

      click_on 'Sign up'
    end

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    open_email('unregistered_user@test.com')

    expect(current_email).to have_content 'Welcome unregistered_user@test.com!'

    current_email.click_link 'Confirm My Account'

    expect(page).to have_content 'Your email address has been successfully confirmed'
  end

  scenario 'user tries to sign up with errors' do
    within '.card-body' do
      click_on 'Sign up'
    end

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
