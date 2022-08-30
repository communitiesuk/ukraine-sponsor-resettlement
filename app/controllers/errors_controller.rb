class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def reference_not_found
    render status: :not_found
  end

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.any  { head :not_found, "content_type" => "text/plain" }
    end
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def too_many_requests
    render status: :too_many_requests
  end
end
