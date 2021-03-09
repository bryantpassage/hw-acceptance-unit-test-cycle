class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if !params.include?(:back) && !params.include?(:home)
      session.clear
    end
    
    if !params.include?(:ratings) && !params.has_key?(:home) then
      if session.has_key?(:ratings) then
        @ratings_to_show = session[:ratings]
      else
        @ratings_to_show = []
      end
    elsif !params.include?(:ratings)
      @ratings_to_show = []
      session[:ratings] = @ratings_to_show
    else
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show
    end
    
    if params.has_key?(:sort) && params[:sort].length() > 0 then
      @sort_by = params[:sort]
      session[:sort] = @sort_by
    else
      if session.has_key?(:sort)
        @sort_by = session[:sort]
      else
        @sort_by = nil
      end
    end
    
    @movies = Movie.get_movies(@sort_by, @ratings_to_show)
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
  
  def search
    @movie_query = Movie.find(params[:id])
    @director_name = @movie_query.director
    @movies = Movie.find_same_director(@movie_query)
    if @movies.nil? then
      flash[:notice] = "'#{@movie_query.title}' has no director information"
      redirect_to movies_path(back:1)     #added wildcard param :back so that session does not clear and flash notice disappears
    end
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
