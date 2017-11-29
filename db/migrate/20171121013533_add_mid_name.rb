class AddMidName < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :mid_name, :string
  end
end
