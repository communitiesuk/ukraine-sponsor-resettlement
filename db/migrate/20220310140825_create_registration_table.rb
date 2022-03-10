class CreateRegistrationTable < ActiveRecord::Migration[7.0]
  def change
    create_table :registrations do |t|
      t.uuid :reference
      t.datetime :transferred_at

      t.timestamps
    end
  end
end
