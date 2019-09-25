require 'net/http'

module Common
	extend ActiveSupport::Concern
	#application_controller
	def set_current_user
		@current_user = User.find_by(id: session[:user_id])
	end

	def authenticate_user
		if @current_user == nil
			flash[:notice] = "Please login to access"
			redirect_to login_path
		end
	end

	def restrict_current_user
		if @current_user
			flash[:notice] = "You already logged in"
			redirect_to root_path
		end
	end	
	
	#users_controller
	def ensure_correct_user
		if @current_user.id != params[:id].to_i
			flash[:notice] = "You have no right to access"
			redirect_to root_path
		end 
	end

	#shops_controller
	def get_response_from_api(url, prms)
=begin
		Parameters
		---------------
		url: string
			url to get response from
			example
			"https://api.gnavi.co.jp/RestSearchAPI/v3/"
		prms: string
			request parameters to pass to the url
			example
			"keyid=KEY_ID&latitude=12.345&longitude=123.4"
		
		Returns
		---------------
		result: hash
			response
=end
		
		parsed_url = URI.parse(url + "?" + prms)
		http = Net::HTTP.new(parsed_url.host, parsed_url.port)
		http.use_ssl = (parsed_url.scheme == 'https')
		response = http.get(parsed_url.request_uri)
		result = JSON.parse(response.body)

	end
	
	def get_restaurants_info(search_word, latitude, longitude)

=begin
		get restaurants from gnavi api 
		Parameters
		---------------
		latitude: string
			string of latitude
			example
			"23.45678"
		longitude: string
			string of longitude
			example
			"123.4567"
		search_word: string
			search word for the case geolocation is missing
			"渋谷"
		Returns
		---------------
		shops: hash
			restaurants list
=end


		key_id = "6463bc55622ce5ad6df3afe4bd4d9815"
		url = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
		prms = ""
		if (latitude.present? && longitude.present?)
			prms = URI.encode_www_form(
				{
				#https://api.gnavi.co.jp/api/manual/restsearch/
				    keyid: key_id,
				    latitude: latitude,
				    longitude: longitude,
				    range: 4,
				    hit_per_page: 2
				}
			)
		elsif (params[:search].present?)
			prms = URI.encode_www_form(
				{
				    keyid: key_id,
				    address: search_word,
				    hit_per_page: 2
				}
			)
		end
		result = get_response_from_api(url, prms)
		shops = result["rest"]
		
	end

	def get_restaurants_info_from_id(shop_ids)

=begin
		get restaurants from gnavi api 
		Parameters
		---------------
		shpp_ids: sequence of string
			sequence of shop id
			example
			["g325200", "a801204", "a801201"]
		Returns
		---------------
		shops: hash
			restaurants list
=end
		
		if shop_ids.empty?
			return
		end

		ids = ""
		shop_ids.each_with_index do |shop_id, idx|
			ids += shop_id
			if idx != shop_ids.size-1
				ids += ","
			end
		end

		key_id = "6463bc55622ce5ad6df3afe4bd4d9815"
		url = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
		prms = ""
		prms = URI.encode_www_form(
			{
			#https://api.gnavi.co.jp/api/manual/restsearch/
			    keyid: key_id,
			    id: ""
			}
		)

		prms += ids
		result = get_response_from_api(url, prms)
		shops = result["rest"]
	end

	def get_restaurants_review(shop_ids)

=begin
		get restaurants from gnavi api 
		Parameters
		---------------
		shop_ids: sequence of string
			sequence of shop id
			example
			["g325200", "a801204", "a801201"]
		Returns
		---------------
		reviews: hash
			reviews list of restaurants
=end
		
		if shop_ids.empty?
			return
		end

		ids = ""
		shop_ids.each_with_index do |shop_id, idx|
			ids += shop_id
			if idx != shop_ids.size-1
				ids += ","
			end
		end

		key_id = "6463bc55622ce5ad6df3afe4bd4d9815"
		url = "https://api.gnavi.co.jp/PhotoSearchAPI/v3/"
		prms = ""
		
		prms = URI.encode_www_form(
			{
			#https://api.gnavi.co.jp/api/manual/restsearch/
			    keyid: key_id,
			    shop_id: "",
			}
		)
		prms += ids

		result = get_response_from_api(url, prms)
		result = result["response"]

		reviews = []

		if result.blank?
			return reviews
		end
		#["@attributes", {"api_version"=>"v3"}] at index 0
		#["total_hit_count", 3] at index 1
		#["hit_per_page", 15] at index 2
		#["0", {review}]  at index 3
		#["1", {review}]  at index 4
		#["2", {review}]  at index 5
		record_starts_from = 3
		result.each_with_index do |item, idx|
			#record is from index 3
			if idx >= record_starts_from
			    reviews.push(item[1]["photo"])
			end
		end
		return reviews
	end

	def get_scores(shop_ids)
		#calculate average rating of reviews 
		reviews = get_restaurants_review(shop_ids)
		scores = {}

		shop_ids.each_with_index do |shop_id, idx|
			sum = 0.0
			cnt = 0
			reviews.each do |review|
				if review["shop_id"] == shop_id
					sum += review["total_score"].to_d
					cnt += 1
				end
			end
			sum /= cnt
			average = (cnt > 0) ? sum : 0.0
			scores["#{shop_id}"] = average
		end
		return scores
	end

	def get_distance(lng1, lat1, lng2, lat2)
=begin
		get distance of restaurants from search point of (latitude, longitude) 
		Parameters
		---------------
		lng1, lng2: double
			longitude of point 1 or 2
			example
			123.4567
		lat1, lat2: double
			latitude of point 1 or 2
			example
			23.45678

		Returns
		---------------
		distance: doble
			distance of two points
=end


		#radius of the earth (km)
		r = 6378.137

		#convert from degree to radian
		#longitude and latitude for the standard position (search)
		x_1 = 2.0 * Math::PI * lng1 / 360.0
		y_1 = 2.0 * Math::PI * lat1 / 360.0

		#longitude and latitude for the position of interest
		x_2 = 2.0 * Math::PI * lng2 / 360.0
		y_2 = 2.0 * Math::PI * lat2 / 360.0
		
		#https://keisan.casio.jp/exec/system/1257670779
		distance = r * Math.acos(Math.sin(y_1) * Math.sin(y_2) + Math.cos(y_1) * Math.cos(y_2) * Math.cos(x_2 - x_1)) 

	end

	def get_rating(distance, score)
=begin
		get rating from distance and score
		---------------
		distance: double
			distance in km
			example
			1.12
		score: double
			average score of reviews (0.0-5.0)
			example
			3.5
		Returns
		---------------
		rating: doble
			rating of 0.0 - 2.0 (distance: 1.0, score: 1.0)
=end
		rating = score/5.0 + 1/(1+distance**2)
	end
end