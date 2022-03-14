require "securerandom"

class Application < ApplicationRecord
  attr_accessor :sponsor_types, :family_or_single_types, :living_space_types, :mobility_impairments_types, :accommodation_length_types, :dbs_certificate_types,
                :sponsor_type, :family_or_single_type, :living_space_type, :mobility_impairments_type, :accommodation_length_type, :dbs_certificate_type, :single_room_count, :double_room_count, :postcode

  validate :validate_sponsor_type, if: :sponsor_type

  validate :validate_family_or_single_type, if: :family_or_single_type

  validate :validate_living_space_type, if: :living_space_type

  validate :validate_mobility_impairments_type, if: :mobility_impairments_type

  validate :mobility_impairments_type, if: :mobility_impairments_type

  validate :single_room_count, if: :single_room_count

  validate :double_room_count, if: :double_room_count

  validate :postcode, if: :postcode

  validate :accommodation_length_type, if: :accommodation_length_type

  validate :dbs_certificate_type, if: :dbs_certificate_type

  after_initialize :after_initialize
  before_save :serialize
  before_save :generate_reference

  def after_initialize
    @sponsor_types = %i[family_member friend_or_colleague unknown_person]
    @family_or_single_types = %i[family single no_preference]
    @living_space_types = %i[rooms_in_home self_contained_property]
    @mobility_impairments_types = %i[yes no]
    @accommodation_length_types = %i[less_than_3_months 3_to_6_months 6_to_12_months more_than_12_months]
    @dbs_certificate_types = %i[yes no_but_willing no]
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

  def validate_mobility_impairments_type
    unless @mobility_impairments_types.include?(@mobility_impairments_type.to_sym)
      errors.add(:mobility_impairments_type, I18n.t(:choose_option, scope: :error))
    end
  end

  # def single_room_count
  #   unless (@single_room_count == nil) || (@single_room_count =~ /^\d+$/)
  #     errors.add(:single_room_count, I18n.t(:invalid_number, scope: :error))
  #   end
  # end
  #
  # def double_room_count
  #   unless (@double_room_count == nil) || (@double_room_count =~ /^\d+$/)
  #     errors.add(:double_room_count, I18n.t(:invalid_number, scope: :error))
  #   end
  # end

  # def postcode
  #   unless(@postcode == nil) || (@postcode =~ /^\d+$/)
  #     errors.add(:postcode, I18n.t(:invalid_postcode, scope: :error))
  #   end
  # end

  # def accommodation_length_type
  #   unless @accommodation_length_types.include?(@accommodation_length_type.to_sym)
  #     errors.add(:accommodation_length_type, I18n.t(:choose_option, scope: :error))
  #   end
  # end

  def answers
    { sponsor_type:, family_or_single_type:, living_space_type:, mobility_impairments_type:, single_room_count:,
      double_room_count:, postcode:, accommodation_length_type:, dbs_certificate_type:}
  end

private

  def serialize
    self.answers = answers
  end

  def generate_reference
    self.reference = SecureRandom.base64(99).gsub!(/[+=\/]/, "")[0, 10].downcase
  end
end
