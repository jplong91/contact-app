class AddBio < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :bio, :text
  end
end
