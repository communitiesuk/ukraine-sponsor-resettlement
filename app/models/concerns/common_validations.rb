module CommonValidations
  extend ActiveSupport::Concern

  def validate_number_adults
    @is_residential_property    = different_address.present? && different_address.casecmp("NO").zero?
    @is_number_adults_integer   = is_integer?(@number_adults)
    @is_number_children_integer = is_integer?(number_children)

    if @is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_one, scope: :error))
    elsif @is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero?
      errors.add(:number_adults, I18n.t(:number_adults_residential, scope: :error))
    elsif !@is_residential_property && (!@is_number_adults_integer || @number_adults.to_i > 9)
      errors.add(:number_adults, I18n.t(:number_adults_zero, scope: :error))
    elsif !@is_residential_property && @is_number_adults_integer && @number_adults.to_i.zero? && @is_number_children_integer && number_children.to_i.positive?
      errors.add(:number_adults, I18n.t(:child_without_adult, scope: :error))
    end
  end

  def is_integer?(value)
    true if Integer(value, exception: false)
  end
end
