class ApplicationController < ActionController::API
  before_action :authenticate_api_key!
  before_action :authenticate_user!

  respond_to :json

  private 

  def application_api_key
    Rails.application.credentials.config[:api_key] 
  end

  def authenticate_api_key!    
    unless request_api_key.present? && request_api_key == application_api_key
      head(:unauthorized)
    end
  end

  def request_api_key
    request.headers['API-key']
  end
end
