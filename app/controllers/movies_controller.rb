class MoviesController < ApplicationController
	before_action :set_movie, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]

	def index
		@movies = Movie.all
		@current_user = current_user.id
		# puts current_user
	end

	def show
	end

	def new
		@movie = Movie.new
	end

	def edit
	end

	def create
		@movie = Movie.new(movie_params)

		respond_to do |format|
			if @movie.save
				format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
				format.json { render :show, status: :created, location: @movie }
			else
				format.html { render :new }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
      	end
		end
	end

	def update
		respond_to do |format|
			if @movie.update(movie_params)
				format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
				format.json { render :show, status: :ok, location: @movie }
			else
				format.html { render :edit }
				format.json { render json: @movie.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@movie.destroy
		respond_to do |format|
			format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_movie
			@movie = Movie.find(params[:id])
			if recommend_movie = UserMovie.find_by(user_id: current_user.id, movie_id: params[:id])
				@recommend_movie = recommend_movie
			else
				@recommend_movie = UserMovie.new(user_id: current_user.id, movie_id: params[:id])
			end
			# @recommend_movie = UserMovie.find_by(user_id: current_user.id, movie_id: params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def movie_params
			params.require(:movie).permit(:name, :movie_url, :image_url)
		end
end
