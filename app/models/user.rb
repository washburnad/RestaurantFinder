class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, 
    :validatable

  has_many :favorites, class_name: 'UserFavorite'
end
