module HomeHelper
  class Queries
    def initialize(music_type, music_set_nsfw, current_user_id, already_played_redis_key, music_already_played)
      @music_type = music_type
      @music_set_nsfw = music_set_nsfw
      @current_user_id = current_user_id
      @music_already_played = music_already_played
      @already_played_redis_key = already_played_redis_key
    end

    ###
    # Total Songs Count For current NSFW mode
    ###
    def total_song_count
      ar_scope_total_songs = Song
      ar_scope_total_songs = ar_scope_total_songs.where(songs: {user_id: @current_user_id})
      # We want to check this conditionally, as we want both SFW and NSFW in the NSFW mode.
      ar_scope_total_songs = ar_scope_total_songs.where("nsfw = ?", false) if @music_set_nsfw == false
      ar_scope_total_songs.count
    end

    ###
    # Total Songs Count For Current Tag & NSFW Mode
    ###
    def total_song_count_for_tag
      ar_scope_total_songs_for_tag = Song
      ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.joins(taggings: [:tag])
      ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.where(tag: {name: @music_type})
      ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.where(songs: {user_id: @current_user_id})
      ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.where(nsfw: @music_set_nsfw) if @music_set_nsfw == false

      ar_scope_total_songs_for_tag.count
    end

    ###
    # Songs For Current Tag & NSFW Mode
    ###
    def songs
      ar_scope = Song
      ar_scope = ar_scope.joins(taggings: [:tag])
      ar_scope = ar_scope.where(tag: {name: @music_type})
      ar_scope = ar_scope.where(songs: {user_id: @current_user_id})
      # Need this conditionally, as an empty array explodes the query.
      ar_scope = ar_scope.where("songs.id NOT IN (?)", @music_already_played) if REDIS.smembers(@already_played_redis_key).length > 0
      # Need this conditionally, as we want both SFW and NSFW in the NSFW mode.
      ar_scope = ar_scope.where("songs.nsfw = ?", false) if @music_set_nsfw == false
      ar_scope = ar_scope.order("RANDOM()")
      ar_scope = ar_scope.limit(1)

      ar_scope.all
    end
  end
end
