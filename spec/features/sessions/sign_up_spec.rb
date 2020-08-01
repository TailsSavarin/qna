require 'rails_helper'

feature 'User can register in the system', %q(
  In order to fully use the available functionality
  As guest
  I'd like to be able to sign up
) do
  given(:user_params) { attributes_for(:user) }

  background { visit new_user_registration_path }

  scenario 'sign up with valid data' do
    within '.card-body' do
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      fill_in 'Password confirmation', with: user_params[:password]
      click_on 'Sign up'
    end

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    expect(current_path).to eq root_path

    open_email(user_params[:email])

    expect(current_email).to have_content "Welcome #{user_params[:email]}!"

    current_email.click_link 'Confirm My Account'

    expect(page).to have_content 'Your email address has been successfully confirmed'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'sign up with invalid data' do
    within '.card-body' do
      click_on 'Sign up'
    end

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
    expect(current_path).to eq user_registration_path
  end
end
