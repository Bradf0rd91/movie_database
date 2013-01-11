class MoviesController < ApplicationController
def index
  if signed_in?
    @movies = Movie.search params[:search], conditions: { active: '1' }, page: params[:page], per_page: 20, order: :title, sort_mode: :asc
  else
    redirect_to signin_path, flash: { notice: "Please sign in to view this page" }
  end
end

def new
  @movie = Movie.new
end

def create
  @movie = current_user.movies.build(params[:movie])
  if @movie.save
    if @movie.active
      redirect_to root_path, flash: { success: "Movie added!" }
      User.all.each {|user| UserMailer.alert_users(current_user, user,
        @movie).deliver unless user == current_user }
    else
      redirect_to root_path, flash: { success: "Movie requested!" }
      User.all.each {|user| UserMailer.movie_request(current_user,
        user,@movie).deliver unless user == current_user}
    end
    %x[rake ts:rebuild]    
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

def destroy
  movie = Movie.find(params[:id])
  movie.destroy
  if movie.destroyed?
    flash[:notice] = "Movie has been deleted"
  else
    flash[:error] = "Something went wrong"
  end
  redirect_to root_path
end

def checked_out
  @movies = Movie.where("loanee != ''").paginate(page: params[:page], per_page: 20).order('loanee ASC')
end

def requested
  @movies = Movie.where("not active").paginate(page: params[:page], per_page: 20).group('user_id')
end

def my_movies
  @movies = Movie.where("user_id = '#{current_user.id}'").paginate(page: params[:page], per_page: 20).order('title ASC')
end

def wish_list
  # raise params.inspect
  # params[:movie][:active] = '0'
  @movie = current_user.movies.build(params[:movie])
  @movie.active = '0'
  # raise params.inspect
  if @movie.save
    raise @movie.inspect
    User.all.each {|user| UserMailer.movie_request(current_user,
      user,@movie).deliver unless user == current_user}
    redirect_to root_path, flash: { success: "Movie requested!" }
    %x[rake ts:rebuild]
  else
    render 'wish_list', flash: { error: "Something went wrong. Please try again later." }
  end
end
end
