class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @music_set_nsfw = params.fetch("nsfw", "false").downcase == "true"
    @music_already_played = REDIS.smembers("already_played")

    @music_type = params[:tag] || "period"

    @lowest_decibel = current_user.songs.order("decibels ASC").first&.decibels || 0

    ###
    # Total Songs Count For NSFW Mode
    ###
    ar_scope_total_songs = Song
    ar_scope_total_songs = ar_scope_total_songs.where(songs: {user_id: current_user.id})
    # We want to check this conditionally, as we want both SFW and NSFW in the NSFW mode.
    ar_scope_total_songs = ar_scope_total_songs.where("nsfw = ?", false) if @music_set_nsfw == false
    @total_song_count = ar_scope_total_songs.count

    ###
    # Total Songs Count For Current Tag & NSFW Mode
    ###
    ar_scope_total_songs_for_tag = Song
    ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.joins(taggings: [:tag])
    ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.where(tag: {name: @music_type})
    ar_scope_total_songs_for_tag = ar_scope_total_songs_for_tag.where(songs: {user_id: current_user.id, nsfw: @music_set_nsfw})
    @total_song_count_for_tag = ar_scope_total_songs_for_tag.count

    ###
    # Songs For Current Tag & NSFW Mode
    ###
    ar_scope = Song
    ar_scope = ar_scope.joins(taggings: [:tag])
    ar_scope = ar_scope.where(tag: {name: @music_type})
    ar_scope = ar_scope.where(songs: {user_id: current_user.id})
    # Need this conditionally, as an empty array explodes the query.
    ar_scope = ar_scope.where("songs.id NOT IN (?)", @music_already_played) if REDIS.smembers("already_played").length > 0
    # Need this conditionally, as we want both SFW and NSFW in the NSFW mode.
    ar_scope = ar_scope.where("songs.nsfw = ?", false) if @music_set_nsfw == false
    ar_scope = ar_scope.order("RANDOM()")
    ar_scope = ar_scope.limit(1)
    @songs = ar_scope.all

    @tags = Tag.all
    
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
