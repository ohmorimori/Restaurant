class ShopsController < ApplicationController
	include Common
	def index
		@shops = get_restaurants_info(
				search_word=params[:search],
				latitude=params[:lat],
				longitude=params[:lng]
			)

		#unnecessary to calculate distance if no map info 
=begin
		if @shops.blank? || params[:lat].blank? || params[:lng].blank?
			return
		end
=end
		if @shops.blank?
			return
		end
		#for each shop
		@shops.each do |shop|
			#calculate distance from search point
			distance = get_distance(
					lng1=longitude.to_d,
					lat1=latitude.to_d,
					lng2=shop["longitude"].to_d,
					lat2=shop["latitude"].to_d
				) 

			#convert distance from km to m
			shop["dist_from_search_point"] = (distance * 1000).to_i
			
			#calculate score
			score = get_score(shop_id=shop["id"])
			shop["score"] = score

			##calculate rating from distance and score
			rating = get_rating(distance, score)
			shop["rating"] = rating
			
		end

		#sort by distance from search point
		#@shops = @shops.sort_by { |shop| shop["dist_from_search_point"].to_d }
		#@shops = @shops.sort_by { |shop| shop["score"].to_d }
		@shops = @shops.sort_by { |shop| -shop["rating"].to_d }
	end
end
