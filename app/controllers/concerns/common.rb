require 'net/http'

module Common
	extend ActiveSupport::Concern
	
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
		result: string
			response in JSON format
=end
		
		parsed_url = URI.parse(url + "?" + prms)
		http = Net::HTTP.new(parsed_url.host, parsed_url.port)
		http.use_ssl = (parsed_url.scheme == 'https')
		response = http.get(parsed_url.request_uri)
		result = JSON.parse(response.body)
		return result
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
				    hit_per_page: 20
				}
			)
		elsif (params[:search].present?)
			prms = URI.encode_www_form(
				{
				    keyid: key_id,
				    address: search_word,
				    hit_per_page: 20
				}
			)
		end

		result = get_response_from_api(url, prms)
		shops = result["rest"]
		return shops
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
		#convert to km -> m
		return (distance * 1000).to_i
		
	end
end