class SongsController < ApplicationController
  def new
    @song = Song.new
  end

  def index
    @songs = current_user.songs.all
  end

  def create
    song = current_user.songs.new(params.require(:song).permit(:title, :url, :start_time, :end_time, :speed, :decibles, :nsfw))
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
    if @song.update(params.require(:song).permit(:title, :url, :start_time, :end_time, :speed, :decibles, :nsfw))
      flash[:notice] = "Song successfully updated"
    else
      puts "unable to update song"
    end

    redirect_to songs_url
  end
end