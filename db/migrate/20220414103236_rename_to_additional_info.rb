class RenameToAdditionalInfo < ActiveRecord::Migration[7.0]
  def change
    rename_table :matches, :additional_info
  end
end
