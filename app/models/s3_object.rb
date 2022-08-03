class S3Object
  attr_accessor :contents,
                :etag,
                :key,
                :last_modified

  after_initialize :after_initialize

  def after_initialize
    @contents = []
  end
end
