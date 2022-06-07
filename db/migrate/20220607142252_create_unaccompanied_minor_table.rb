class CreateUnaccompaniedMinorTable < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :unaccompanied_minors do |t|
      t.string :reference
      t.string :fullname, limit: 128, null: true
      t.string :email, limit: 128, null: true
      t.json :answers, null: true
      t.datetime :transferred_at, null: true
      t.timestamps
    end

    add_index :unaccompanied_minors, :reference, unique: true
  end
end
