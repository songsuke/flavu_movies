class ApplicationController < ActionController::Base
  protect_from_forgery
  protected

  def ssl_required?
    Rails.env.production?
  end
end
