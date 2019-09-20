class ShopsController < ApplicationController
	include Common
	def index
		@shops = get_restaurants_info(
				search_word=params[:search],
				latitude=params[:lat],
				longitude=params[:lng]
			)

		#unnecessary to calculate distance if no map info 
		if @shops.blank?
			return
		end
		#for each shop
		@shops.each do |shop|
			#calculate distance from search point
			distance = get_distance(lng1=longitude.to_d, lat1=latitude.to_d, lng2=shop["longitude"].to_d, lat2=shop["latitude"].to_d) 
			#convert distance from km to m
			shop["dist_from_search_point"] = (distance * 1000).to_i
			#calculate score
			shop["score"] = get_score(shop_id=shop["id"])
			##calculate rating from distance and score
			shop["rating"] = get_rating(distance, score)
		end

		#sort by rating from search point
		@shops = @shops.sort_by { |shop| -shop["rating"].to_d }
	end
end
