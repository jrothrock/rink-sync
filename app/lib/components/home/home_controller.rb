require_relative '_home_helper'

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @music_set_nsfw = params.fetch("nsfw", "false").downcase == "true"
    @music_already_played = REDIS.smembers(already_played_redis_key)

    @music_type = params[:tag] || "period"

    @lowest_decibel = current_user.songs.order("decibels ASC").first&.decibels || 0

    home_queries = HomeHelper::Queries.new(music_type=@music_type, music_set_nsfw=@music_set_nsfw, current_user_id=current_user.id, already_played_redis_keys=already_played_redis_key, music_already_played=@music_already_played)
    @total_song_count = home_queries.total_song_count
    @total_song_count_for_tag = home_queries.total_song_count_for_tag
    @songs = home_queries.songs

    @tags = Tag.all
    
    if @songs.length > 0
      REDIS.sadd(already_played_redis_key, @songs.first.id)
      @music_already_played << @songs.first.id
    end

    render template: "home/views/index"
  end

  def skip_song
    REDIS.srem(already_played_redis_key, params[:song_id])

    redirect_to root_url(nsfw: params[:nsfw], tag: params[:tag])
  end

  def new_game
    REDIS.del(already_played_redis_key)

    redirect_to root_url(nsfw: params[:nsfw])
  end

  private

  def already_played_redis_key
    "already_played_#{current_user.id}"
  end
end
