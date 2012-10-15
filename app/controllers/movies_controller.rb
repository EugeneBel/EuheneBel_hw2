class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
 
    @all_ratings=Movie.all_ratings
    if ((params["ratings"]))
       @rat=params["ratings"].keys
       params.merge({"good"=>"true"})
    else
       @rat=@all_ratings
    end
    @movies = Movie.find_all_by_rating(@rat)
    if (params["sort_by_title"]=="true")
       @movies.sort_by!{|m| m.title}
    end
    if (params["sort_by_release_date"]=="true")
       @movies.sort_by!{|m| m.release_date}
    end

    if ((params["sort_by_title"]||params["ratings"])||(!(session["sort_by_title"]&&session["ratings"])))
    session.clear
    session.merge!(params)
  else
    hs={}
    session.each do |s|
    if (["sort_by_title","sort_by_release_date","ratings"].include?(s[0]))
    hs.merge!({s[0]=>s[1]})
  end
    end
    flash.keep
    redirect_to movies_path(hs)
  end

  end

  def new
    # default: render 'new' template
  end
  def sort_by_title
    redirect_to movies_path
  end
  def sort_by_release_date
    redirect_to movies_path({:sort_by_release_date => true})
  end
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
