class ApplicationController < ActionController::Base
  helper_method :admin?

  private

  def admin?
    current_user&.admin?
  end

  def authenticate_admin!
    redirect_to root_path, alert: 'Not authorized' unless admin?
  end
end
