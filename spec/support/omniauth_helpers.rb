module OmniauthHelpers
  def mock_auth_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid: '123456',
      info: { email: 'github_test@user.com' }
    })
  end

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      info: { email: 'twitter_test@user.com' }
    })
  end
end

