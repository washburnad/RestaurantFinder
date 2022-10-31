class AddUniquenessContraintToUserFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_index :user_favorites, [:user_id, :place_id]
    add_index :user_favorites, [:user_id, :place_id], unique: true
  end
end
