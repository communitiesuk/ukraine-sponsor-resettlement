class CreateRegistrationTable < ActiveRecord::Migration[7.0]
  def change
    create_table :registrations do |t|
      t.integer :Id
      t.uuid :Reference
      t.boolean: IsTransferred
      
      t.timestamps
    end
  end
end
