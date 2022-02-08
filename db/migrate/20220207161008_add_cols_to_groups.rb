class AddColsToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :image, :string
    add_column :groups, :intro, :text
  end
end
