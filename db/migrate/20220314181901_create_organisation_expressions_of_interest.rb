class CreateOrganisationExpressionsOfInterest < ActiveRecord::Migration[7.0]
  def change
    create_table :organisation_expressions_of_interest do |t|
      t.string :reference
      t.string :fullname, limit: 128, null: true
      t.string :email, limit: 128, null: true
      t.json :answers, null: true
      t.datetime :transferred_at, null: true
      t.timestamps
    end

    add_index :organisation_expressions_of_interest, :reference, unique: true
  end
end
