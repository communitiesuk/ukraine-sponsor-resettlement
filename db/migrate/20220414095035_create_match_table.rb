class CreateMatchTable < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :matches, id: :uuid do |t|
      t.string :reference
      t.string :fullname, limit: 128, null: true
      t.string :email, limit: 128, null: true
      t.json :answers, null: true
      t.datetime :transferred_at, null: true
      t.timestamps
    end
  end
end
