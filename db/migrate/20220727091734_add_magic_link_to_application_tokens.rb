class AddMagicLinkToApplicationTokens < ActiveRecord::Migration[7.0]
  def change
    add_column :application_tokens, :magic_link, :string, unique: true
    add_index :application_tokens, :magic_link
  end
end
