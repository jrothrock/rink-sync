class SongsController < ApplicationController
  def new
    @song = Song.new
  end

  def index
    @songs = current_user.songs.all
  end

  def create
    song = current_user.songs.new(song_params)
    if song.save
      flash[:notice] = "Song successfully created"
    else
      puts "Unable to create song"
    end

    redirect_to root_url
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])
    if @song.update(song_params)
      flash[:notice] = "Song successfully updated"
    else
      puts "unable to update song"
    end

    redirect_to songs_url
  end

  private

  def song_params
    params.require(:song).permit(
      :title, 
      :url, 
      :start_time, 
      :end_time,
      :decibels, 
      :nsfw,
      tag_ids: []
    )
  end
end