class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'lol' }
      format.js { render status: :forbidden }
      format.json { render json: {}, status: :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end
