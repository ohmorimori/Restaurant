class RenameColumnToShops < ActiveRecord::Migration[5.2]
  def change
  	rename_column :shops, :name, :shop_id
  end
end
