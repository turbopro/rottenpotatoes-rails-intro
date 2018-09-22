class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  # set sorted column headers
  def header_hilite
    @title_header = 'hilite' if session[:sel_sort] == 'title'
    @release_date_header = 'hilite' if session[:sel_sort] == 'release_date'
  end

  # action for Search TMDB
  def search_tmdb
    # hardwire to simulate failre
    flash[:warning] = "'#{params[:search_terms]}' was not found in TMDB."
    redirect_to movies_path
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # RESTful sort columns action
  def sorting
    @all_ratings = session[:all_ratings]

    session[:sel_sort] = params[:sort] if params[:sort]
    session[:sel_ratings] = params[:ratings].keys if params[:ratings]

    header_hilite

    @checkbox_set = session[:sel_ratings]

    @movies = Movie.movie_list(session[:sel_ratings], session[:sel_sort])
    render 'index'
  end

  def index
    @all_ratings = Movie.ratings

    # if sort or ratings set, redirect to 'sorting' action with params
    if (params[:sort] || params[:ratings])
      session[:all_ratings] = @all_ratings
      redirect_to sorting_movies_path(params)
    end

    # set checkboxes and column headers if session values set
    if session[:sel_sort] || session[:sel_ratings]
      @checkbox_set = session[:sel_ratings]
      header_hilite
    else
      @checkbox_set = session[:sel_ratings] = @all_ratings
    end

    @movies = Movie.movie_list(session[:sel_ratings], session[:sel_sort])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
