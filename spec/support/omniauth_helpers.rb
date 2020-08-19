module OmniauthHelpers
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      {
        provider: 'github',
        uid: '123456',
        info: { email: 'github_test@user.com' }
      }
    )
  end

  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      {
        provider: 'facebook',
        uid: '123456',
        info: { email: 'facebook_test@user.com' }
      }
    )
  end
end
