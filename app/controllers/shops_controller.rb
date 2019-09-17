require 'net/http'

class ShopsController < ApplicationController

	def index
		
		#prevent blank search window to return restaurants all around japan 
		if (params[:search] == "") 
			return
		end

		url = "https://api.gnavi.co.jp/RestSearchAPI/v3/";
		prms = URI.encode_www_form(
			{
			#https://api.gnavi.co.jp/api/manual/restsearch/
			    keyid: "6463bc55622ce5ad6df3afe4bd4d9815",
			    latitude: params[:lat],
			    longitude: params[:lng],
			    range: 4,
			    hit_per_page: 20
			}
		)
		parsed_url = URI.parse(url + "?" + prms)

		http = Net::HTTP.new(parsed_url.host, parsed_url.port)
		http.use_ssl = (parsed_url.scheme == 'https')
		response = http.get(parsed_url.request_uri)
		result = JSON.parse(response.body)
		@shops = result["rest"]
		
		if !@shops
			return
		end
		
		#calculate distance of two points based on longitude and latitude
		@shops.each do |shop|
			#radius of the earth (km) around the equator
			r = 6378.137

			#longitude and latitude for the standard position (search)
			x_1 = 2.0 * Math::PI * params[:lng].to_d / 360.0
			y_1 = 2.0 * Math::PI * params[:lat].to_d / 360.0

			#longitude and latitude for the position of interest
			x_2 = 2.0 * Math::PI * shop["longitude"].to_d / 360.0
			y_2 = 2.0 * Math::PI * shop["latitude"].to_d / 360.0
			
			#https://keisan.casio.jp/exec/system/1257670779
			distance = r * Math.acos(Math.sin(y_1) * Math.sin(y_2) + Math.cos(y_1) * Math.cos(y_2) * Math.cos(x_2 - x_1)) 
			shop["dist_from_search_point"] = distance
		end

		#sort by distance from serch point
		@shops = @shops.sort_by { |shop| shop["dist_from_search_point"].to_d }

	end
end
