# encoding: utf-8

namespace :create_sample do
	desc "Movieのサンプルデータ作成" #=> 説明

# $ rake create_sample:create_movie
# :environmentは超大事。ないとモデルにアクセスできない
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
end