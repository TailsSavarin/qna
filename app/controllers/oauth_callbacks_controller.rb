class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authentication_with_oauth
  end

  def twitter
    authentication_with_oauth
  end

  private

  def authentication_with_oauth
    @user = User.find_for_oauth(auth_hash)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
