class MoviesController < ApplicationController
def index
  # @movies = Movie.paginate(per_page: 20, page: params[:page])
  @movies = Movie.search params[:search]
end

def edit
  @movie = Movie.find(params[:id])
end

def update
  @movie = Movie.find(params[:id])
  if @movie.update_attributes(params[:movie])
    flash[:notice] = "Movie was successfully updated"
  else
    flash[:error] = "Movie was not changed"
  end
  redirect_to root_path
end

def checked_out
  @movies = Movie.where("loanee != ''")
end

def search
end

def results
  @search = params[:search]
  raise @search.inspect
end
end
