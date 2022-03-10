class CreateRegistrationTable < ActiveRecord::Migration[7.0]
  def change
    create_table :registrations do |t|
      t.uuid :reference
      t.boolean :is_transferred

      t.timestamps
    end
  end
end
