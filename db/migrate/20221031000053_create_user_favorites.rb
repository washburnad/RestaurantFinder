class CreateUserFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :user_favorites do |t|
      t.id :user_id
      t.string :place_id
      t.timestamps
    end

    add_index :user_favorites, [:user, :place_id]
  end
end
