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
    # get list of all ratings
    @all_ratings = Movie.ratings

    # set header css attributes
    @title_header = 'hilite' if params[:sort] == 'title'
    @release_date_header = 'hilite' if params[:sort] == 'release_date'

    # first request: params[:ratings] and params[:sort] are nil
    # store @all_ratings in session[:sel_ratings]
    if params[:ratings].nil? && params[:sort].nil?
      session[:sel_ratings] = @all_ratings
    end
    # if params[:ratings], store in session[:sel_ratings]
    session[:sel_ratings] = params[:ratings].keys if params[:ratings]

    @movies = Movie.movie_list(session[:sel_ratings], params[:sort])
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
