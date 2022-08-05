class S3BucketController < ApplicationController
  def list_objects
    if Rails.env.production?
      render nothing: true, status: :method_not_allowed
    end

    @objects = S3Object.new

    @service = StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])

    resp = @service.list_objects

    Rails.logger.debug "****************************************************************"
    Rails.logger.debug "Bucket response: #{resp.to_h}"
    Rails.logger.debug "****************************************************************"

    # @objects.contents = resp
    @entries = resp.contents
  end
end
