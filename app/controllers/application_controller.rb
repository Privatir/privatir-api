class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  def fallback_index_html
    render :file => 'public/index.html'
  end
  
  private
  
  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
