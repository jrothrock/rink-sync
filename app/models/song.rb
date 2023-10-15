class Song < ApplicationRecord
  belongs_to :user

  def is_soundcloud?
    url.include?("soundcloud")
  end

  def is_youtube?
    url.include?("youtube")
  end
end