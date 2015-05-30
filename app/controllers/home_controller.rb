class HomeController < ApplicationController
  def index
  	user = UserMovie.where(user_id: 1)
    render text: user.class
    # user.each do |u|
    #   render json: u.class
    #   return
    # end
  end

  def show
    user = User.find_by(id: 1)
  	movie = Movie.find_by(id: 3)

  	user_movie = user.user_movies.find_by(movie_id: movie.id)
    # render json: user_movie
    # return

  	if user_movie
  		user_movie.star = 5
      user_movie.save
  	else
  		user_movie_new = UserMovie.new
  		user_movie_new.user_id = user.id
  		user_movie_new.movie_id = movie.id
  		user_movie_new.star = 0
  		user_movie_new.save
  	end

  
  	render json: UserMovie.all
  end
end
