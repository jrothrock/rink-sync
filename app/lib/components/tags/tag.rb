class Tag < ApplicationRecord
  has_many :taggings
  has_many :songs, through: :taggings
end
