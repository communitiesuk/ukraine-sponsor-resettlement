class ExtractDocumentController < ApplicationController
  def list_objects
    @objects = S3Object.new

    @service = StorageService.new(PaasConfigurationService.new, ENV["INSTANCE_NAME"])
    @objects.contents = @service.list_objects
  end
end
