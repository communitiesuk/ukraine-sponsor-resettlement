class IndividualExpressionOfInterest < ApplicationRecord
  include CommonValidations

  self.table_name = "matches"

  SCHEMA_VERSION = 2
  
end
