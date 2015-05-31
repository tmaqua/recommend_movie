class HomeController < ApplicationController
	include CollaborativeFiltering

	before_action :authenticate_user!, only: [:similar_user, :recommend_movie]
  
	def index
		@user_movies = UserMovie.all
	end

	def show
	end

	def similar_user
		prefs = create_prefs_hash
		@matches = top_matches(prefs, current_user.id.to_s)
		render text: @matches
	end

	def recommend_movie
		prefs = create_prefs_hash
		@item = get_recommendations(prefs, current_user.id.to_s)
		render text: @item
	end

	def similar_movie
		menu = transform_prefs(create_prefs_hash)
		@item = top_matches(menu, params[:item])
		render text: @item
	end

	private
		def create_prefs_hash()
			users = User.pluck(:id) # => [1,2,3,4,5]
			prefs = Hash.new

			users.each do |user|
				user_movie = UserMovie.where(user_id: user)
				evaluated_movie = Hash.new
				user_movie.each do |movie|
					evaluated_movie.store("#{movie.movie_id}", movie.star)
				end
				prefs.store("#{user}", evaluated_movie)
			end
		prefs
	end
end
