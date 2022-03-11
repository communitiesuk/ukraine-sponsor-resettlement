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
    @sponsor_types = %i[family_member friend_or_colleague unknown_person]
    @family_or_single_types = %i[family single no_preference]
    @living_space_types = %i[rooms_in_home self_contained_property]
  end

  def validate_sponsor_type
    unless @sponsor_types.include?(@sponsor_type.to_sym)
      errors.add(:sponsor_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_family_or_single_type
    unless @family_or_single_types.include?(@family_or_single_type.to_sym)
      errors.add(:family_or_single_type, I18n.t(:choose_option, scope: :error))
    end
  end

  def validate_living_space_type
    unless @living_space_types.include?(@living_space_type.to_sym)
      errors.add(:living_space_type, I18n.t(:choose_option, scope: :error))
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
    self.reference = SecureRandom.base64(99).gsub!(/[+=\/]/, "")[0, 10].downcase
  end
end
