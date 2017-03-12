class ApplicationController < ActionController::Base
  UPDATEABLE_DEVISE_KEYS = [
    :phone_number,
    :time_zone
  ].freeze

  protect_from_forgery with: :exception

  around_action :set_time_zone, if: :current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: UPDATEABLE_DEVISE_KEYS )
    devise_parameter_sanitizer.permit(:account_update, keys: UPDATEABLE_DEVISE_KEYS )
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
