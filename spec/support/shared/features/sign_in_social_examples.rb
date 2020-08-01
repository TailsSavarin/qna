shared_examples 'sign in features' do
  scenario 'try to sign in' do
    mock_auth
    click_on "Sign in with #{social_network}"

    expect(page).to have_content "Successfully authenticated from #{social_network.capitalize} account."
  end

  scenario 'handle authentication error' do
    mock_auth_invalid
    click_on "Sign in with #{social_network}"

    expect(page).to have_content %(Could not authenticate you from #{social_network} because "Invalid credentials")
  end
end
