class CreateApplicationTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :application_tokens do |t|
      t.string :token
      t.datetime :expires_at, null: true
      t.references :unaccompanied_minor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
