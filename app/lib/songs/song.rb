class Song < ApplicationRecord
  belongs_to :user

  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings

  def is_soundcloud?
    url.include?("soundcloud")
  end

  def is_youtube?
    url.include?("youtube")
  end
end