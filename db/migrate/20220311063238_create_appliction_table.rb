class CreateApplictionTable < ActiveRecord::Migration[7.0]
  def change
    create_table :applictions do |t|

      t.timestamps
    end
  end
end
