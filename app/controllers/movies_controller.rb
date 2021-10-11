class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    @all_ratings = Movie.uniq.pluck(:rating)
    @ratings_to_show
          
    
    
    if params[:ratings] 
      @ratings_to_show = params[:ratings].keys
      @rating_hash = Hash[@ratings_to_show.collect{|key| [key, '1']}]
    
      session[:ratings] = @rating_hash #!!
      
      if params[:sortBy]
         session[:sortBy] = params[:sortBy] #!!
         @movies = Movie.with_ratings(params[:ratings].keys).order(params[:sortBy])
      else
         @movies = Movie.with_ratings(params[:ratings].keys)
      end

    else 
      @ratings_to_show = @all_ratings
      
      if params[:sortBy]
         
        session[:sortBy] = params[:sortBy] #!!

         @movies = Movie.with_ratings([]).order(params[:sortBy])
      else
         @movies = Movie.with_ratings([])
      end
      
    end
      
    
    
    if params[:sortBy] == 'title'
      @title_class = 'hilite'
    elsif params[:sortBy] == 'release_date'
      @date_class = 'hilite' 
    end
    
    
    
    if (!params[:ratings] && !params[:sortBy] && !session.empty?)
      if !params[:commit]
          if (session.has_key?(:ratings) && session.has_key?(:sortBy))
            redirect_to movies_path(:ratings=>session[:ratings], :sortBy => session[:sortBy])
          elsif (!session.has_key?(:ratings) && session.has_key?(:sortBy))
              redirect_to movies_path(:sortBy => session[:sortBy])
          elsif (session.has_key?(:ratings) && !session.has_key?(:sortBy))
              redirect_to movies_path(:ratings=>session[:ratings])
          end
      else 
        session.clear
      end
    end

    
    
    
    
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
