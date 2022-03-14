class RenameToExpressionsOfInterest < ActiveRecord::Migration[7.0]
  def change
    rename_table :applications, :individual_expressions_of_interest
  end
end
