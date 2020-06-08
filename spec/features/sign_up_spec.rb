require 'rails_helper'

feature 'User can register in the system', %q(
  In order to fully use the available functionality
  As an unregistered user
  I'd like to be able to sign up
) do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'User tries to sign up with valid data' do
    fill_in 'Email', with: 'unregistered_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with blank email' do
    fill_in 'Email', with: nil
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content "Email can't be blank"
  end

  scenario 'User tries to sign up with blank password' do
    fill_in 'Email', with: 'correct_email1@test.com'
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'User tries to sign up with invalid email' do
    fill_in 'Email', with: '@'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Email is invalid'
  end

  scenario 'User tries to sign up with too short password' do
    fill_in 'Email', with: 'correct_email2@test.com'
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'User tries to sign up with too long password' do
    fill_in 'Email', with: 'correct_email4@test.com'
    fill_in 'Password', with: '999' * 999
    fill_in 'Password confirmation', with: '999' * 999
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Password is too long (maximum is 128 characters)'
  end

  scenario "User tries to sign up with doesn't match password" do
    fill_in 'Email', with: 'correct_email3@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'User tries to sign up with already taken email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    # save_and_open_page
    expect(page).to have_content 'Email has already been taken'
  end
end
