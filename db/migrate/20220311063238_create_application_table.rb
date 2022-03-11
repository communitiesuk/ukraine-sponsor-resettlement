class CreateApplicationTable < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :applications, id: :uuid do |t|
      t.string :reference
      t.integer :version
      t.datetime :transferred_at
      t.timestamps
    end
  end
end
