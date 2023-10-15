class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @music_set_nsfw = params.fetch("nsfw", "false").downcase == "true"
    @music_already_played = REDIS.smembers("already_played")

    @lowest_decibel = current_user.songs.order("decibles ASC").first.decibles

    ar_scope_total_songs = Song
    ar_scope_total_songs = ar_scope_total_songs.where(songs: {user_id: current_user.id})
    ar_scope_total_songs = ar_scope_total_songs.where("nsfw = ?", false) if @music_set_nsfw == false
    @total_song_count = ar_scope_total_songs.count

    ar_scope = Song
    ar_scope = ar_scope.where(songs: {user_id: current_user.id})
    ar_scope = ar_scope.where("id NOT IN (?)", @music_already_played) if REDIS.smembers("already_played").length > 0
    ar_scope = ar_scope.where("nsfw = ?", false) if @music_set_nsfw == false
    ar_scope = ar_scope.order("RANDOM()")
    ar_scope = ar_scope.limit(1)
    @songs = ar_scope.all
    
    if @songs.length > 0
      REDIS.sadd("already_played", @songs.first.id)
      @music_already_played << @songs.first.id
    end
  end

  def new_game
    REDIS.del("already_played")

    redirect_to root_url(nsfw: params[:nsfw])
  end
end
