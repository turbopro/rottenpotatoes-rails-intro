class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    # get list of all ratings
    @all_ratings = Movie.ratings

    # set session variables
    if params[:sort]
      redirect_to movies_path(session[:sel_sort] = params[:sort])
    end
    if params[:ratings]
      redirect_to movies_path(session[:sel_ratings] = params[:ratings].keys)
    end
    #session[:sel_ratings] = params[:ratings].keys if params[:ratings]
    #session[:sel_sort]    = params[:sort] if params[:sort]

    # set header css attributes
    @title_header = 'hilite' if session[:sel_sort] == 'title'
    @release_date_header = 'hilite' if session[:sel_sort] == 'release_date'

    # set session parameters for initial page opening
    if session[:sel_ratings].nil? && session[:sel_sort].nil?
      @checkbox_set = session[:sel_ratings] = @all_ratings
      #@checkbox_set = @all_ratings
    else
      @checkbox_set = session[:sel_ratings]
    end

    # @checkbox_set used to display checkboxes set in view
    #@checkbox_set = session[:sel_ratings]

    # get movies
    @movies = Movie.movie_list(session[:sel_ratings], session[:sel_sort])
    #debugger
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
