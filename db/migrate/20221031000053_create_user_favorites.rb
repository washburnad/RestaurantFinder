class CreateUserFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :user_favorites do |t|
      t.belongs_to :user, index: false
      t.string :place_id
      t.timestamps
    end

    add_index :user_favorites, [:user_id, :place_id]
  end
end
