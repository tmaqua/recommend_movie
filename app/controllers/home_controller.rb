class HomeController < ApplicationController
	include CollaborativeFiltering

	before_action :authenticate_user!, only: [:similar_user, :recommend_movie]

	def index
		@user_movies = UserMovie.all
	end

	def show
	end

	def similar_user
		@similar_users = Array.new
		if UserMovie.find_by(id: current_user.id)
			user_num = User.pluck(:id).size
			prefs = create_prefs_hash
			matches = top_matches(prefs, current_user.id.to_s, user_num)
			@testvalue = matches
			matches.each do |user|
				temp = Hash.new
				temp[:value] = user[0]
				temp[:username] = User.find_by(id: user[1]).username
				@similar_users.push(temp)
			end
		end
		@similar_users
	end

	def recommend_movie
		prefs = create_prefs_hash
		items = get_recommendations(prefs, current_user.id.to_s)
		@recommend_movies = Array.new
		items.each do |item|
			temp = Hash.new
			movie = Movie.find_by(id: item[1])
			temp[:value] = item[0]
			temp[:movie_id] = movie.id
			temp[:image_url] = movie.image_url
			temp[:name] = movie.name
			@recommend_movies.push(temp)
		end
		@recommend_movies
	end

	def similar_movie
		menu = transform_prefs(create_prefs_hash)
		@items = top_matches(menu, params[:item])
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
