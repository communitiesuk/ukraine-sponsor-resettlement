class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def too_many_requests
    render status: :too_many_requests
  end
end
