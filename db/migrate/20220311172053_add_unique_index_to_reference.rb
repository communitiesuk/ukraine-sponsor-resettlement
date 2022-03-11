class AddUniqueIndexToReference < ActiveRecord::Migration[7.0]
  def change
    add_index :applications, :reference, unique: true
  end
end
