class UserMoviesController < ApplicationController
	before_action :set_user_movie, only: [:show, :edit, :update]
	before_action :authenticate_user!, only: [:index, :show, :edit, :update]

	def index
		@evaluated_movies = UserMovie.where(user_id: current_user.id)
	end

	def show
	end

	def edit
	end

	def update
		respond_to do |format|
			if @evaluated_movie.update(evaluated_movie_params)
				format.html { redirect_to @evaluated_movie, notice: 'Star was successfully updated.' }
				format.json { render :show, status: :ok, location: @evaluated_movie }
			else
				format.html { render :edit }
				format.json { render json: @evaluated_movie.errors, status: :unprocessable_entity }
			end
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_user_movie
			@evaluated_movie = UserMovie.find(params[:id])
			@movie = Movie.find_by(id: @evaluated_movie.movie_id)
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def evaluated_movie_params
			params.require(:user_movie).permit(:star)
		end
end
