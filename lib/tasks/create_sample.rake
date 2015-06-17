# encoding: utf-8
require 'net/http'

namespace :create_sample do
	
	# $ rake create_sample:create_movie
	desc "Movieのサンプルデータ作成" #=> 説明
	task :create_movie => :environment do 

		# 楽天apiにアクセス
		url = URI.parse("https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?f")
		parameters = {
			# 必須パラメータ
			:format => "json",
			:applicationId => "1053904573776057358",

			# ジャンルID
			:genreId => 101360
		}

		# パラメータをエンコード
		url.query = URI.encode_www_form(parameters)
		res = Net::HTTP.get_response(url)
		result_api = JSON.parse(res.body, symbolize_names: true)

		if result_api.nil?
			print("error\n")
			return
		else
			print("get data for rakuten\n")

			# DBに登録
			result_api[:Items].each do |item|
				movie_new = Movie.new
				movie_new.name = item[:Item][:itemName]
				movie_new.movie_url = item[:Item][:itemUrl]
				if item[:Item][:mediumImageUrls].empty?
					movie_new.image_url = ""
				else
					movie_new.image_url = item[:Item][:mediumImageUrls][0][:imageUrl]
				end
				movie_new.save
			end
		end

		print("saved sample data\n")
	end

	# $ rake create_sample:create_evaluated_movie
	desc "評価済み映画の作成"
	task :create_evaluated_movie => :environment do

		UserMovie.destroy_all

		5.times do |u|
			# 10個分データ作成
			10.times do |n|
				user = User.find_by(id: u+1)
  				movie = Movie.find_by(id: rand(30)+1)

  				user_movie = user.user_movies.find_by(movie_id: movie.id)

  				if user_movie
  					user_movie.star = rand(10)+1
      			user_movie.save
  				else
  					user_movie_new = UserMovie.new
  					user_movie_new.user_id = user.id
  					user_movie_new.movie_id = movie.id
  					user_movie_new.star = rand(10)+1
  					user_movie_new.save
  				end
			end
		end
		print("success\n")
	end
end