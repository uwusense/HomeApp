class ApplicationController < ActionController::Base
  before_action :set_locale

  helper_method :admin?

  private

  def admin?
    current_user&.admin?
  end

  def authenticate_admin!
    redirect_to root_path, alert: t(:not_authorized) unless admin?
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    if I18n.available_locales.map(&:to_s).include?(parsed_locale)
      parsed_locale.to_sym
    else
      nil
    end
  end
end
