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
    
    #session.destroy
    
    sort_type = params[:sort_type]  || session[:sort_type]
    
    @all_ratings = ["G",  "PG",  "PG-13" ,  "NC-17",  "R"]
    
    rating_hash = { "G" => 1,  "PG" => 1,  "PG-13" => 1,  "NC-17" => 1,  "R" => 1}
    
    @checked_ratings =  params[:ratings] || session[:ratings] || {}
    
    initial_rating  = @checked_ratings
    
     if @checked_ratings.empty?
      initial_rating = rating_hash
    end
    
    if params[:sort_type] != session[:sort_type] or params[:ratings] != session[:ratings]
      session[:sort_type] = params[:sort_type]
      session[:ratings] = params[:ratings]
      redirect_to :sort_type => sort_type, :ratings => @checked_ratings and return
    end
    
    @movies =  Movie.order(sort_type).where('rating IN (?)', initial_rating.keys).all
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.ti
    origin_rating = tle} was successfully created."
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
