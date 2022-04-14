class IndividualExpressionOfInterest < ApplicationRecord
  include CommonValidations

  self.table_name = "matches"

  SCHEMA_VERSION = 2

  attr_accessor :email, :fullname

  after_initialize :after_initialize
  before_save :serialize

  after_find do
    assign_attributes(answers)
  end

  def after_initialize
    @final_submission = false
  end

  def as_json
    {
        id:,
        reference:,
        created_at:,
        type:,
        version:,
        email:,
        fullname:,
        started_at:,
    }.compact
  end

  private

  def serialize
    self.type = "match"
    self.version = SCHEMA_VERSION
    self.answers = as_json
  end
end
