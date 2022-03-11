class CreateApplicationTable < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :reference
      t.integer :version
      t.datetime :transferred_at
      t.timestamps
    end
  end
end
