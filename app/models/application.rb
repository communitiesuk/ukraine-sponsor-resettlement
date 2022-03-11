require "securerandom"

class Application < ApplicationRecord
  attr_accessor :sponsor_types, :family_or_single_types, :living_space_types, :sponsor_type, :family_or_single_type, :living_space_type

  validate :validate_sponsor_type, if: :sponsor_type

  validate :validate_family_or_single_type, if: :family_or_single_type

  validate :validate_living_space_type, if: :living_space_type

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  def after_initialize
    @sponsor_types = ["Family Member", "Friend or Colleague", "Unknown Person"]
    @family_or_single_types = ["Family", "Single person", "No preference"]
    @living_space_types = ["Rooms in your home", "A self-contained property (includes at least 1 bedroom, bathroom and kitchen)"]
  end

  def validate_sponsor_type
    unless @sponsor_types.include?(@sponsor_type)
      errors.add(:sponsor_type, "Please choose one of the options")
    end
  end

  def validate_family_or_single_type
    unless @family_or_single_types.include?(@family_or_single_type)
      errors.add(:family_or_single_type, "Please choose one of the options")
    end
  end

  def validate_living_space_type
    unless @living_space_types.include?(@living_space_type)
      errors.add(:living_space_type, "Please choose one of the options")
    end
  end

  def answers
    { sponsor_type:, family_or_single_type:, living_space_type: }
  end

private

  def serialize
    self.answers = answers
  end

  def generate_reference
    self.reference = SecureRandom.base64(99).gsub!(/[+=\/]/, "*")[0, 10].downcase
  end
end
