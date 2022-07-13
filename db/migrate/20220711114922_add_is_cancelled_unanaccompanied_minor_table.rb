class AddIsCancelledUnanaccompaniedMinorTable < ActiveRecord::Migration[7.0]
  def change
    add_column :unaccompanied_minors, :is_cancelled, :boolean, default: false
  end
end
