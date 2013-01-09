class MoviesController < ApplicationController
def index
  # @movies = Movie.paginate(per_page: 20, page: params[:page])
  if signed_in?
    @movies = Movie.search params[:search], page: params[:page], per_page: 20, order: :title, sort_mode: :asc
  else
    redirect_to signin_path, flash: { notice: "Please sign in to view this page" }
  end
end

def new
  @movie = Movie.new
end

def create
  @movie = current_user.movies.build(params[:movie])
  # raise @movie.inspect
  if @movie.save
    redirect_to root_path, flash: { success: "Movie added!" }
    %x[rake ts:rebuild]
    User.all.each {|user| UserMailer.alert_users(current_user, user,
      @movie).deliver unless user == current_user }
  else
    render 'new', flash: { error: "That movie was invalid" }
  end
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
  @movies = Movie.where("loanee != ''").paginate(page: params[:page], per_page: 20).order('loanee ASC')
end

def my_movies
  @movies = Movie.where("user_id = '#{current_user.id}'").paginate(page: params[:page], per_page: 20).order('title ASC')
end

def wish_list
  raise params.inspect
  @movie = params[:movie]
  # @movie = Movie.new
  User.all.each {|user| UserMailer.movie_request(current_user,
    user,@movie).deliver unless user == current_user}
  # @movie.destroy
end
end
