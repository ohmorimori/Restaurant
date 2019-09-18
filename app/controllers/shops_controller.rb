class ShopsController < ApplicationController
	include Common
	def index
		@shops = get_restaurants_info(
				search_word=params[:search],
				latitude=params[:lat],
				longitude=params[:lng]
			)

		#unnecessary to calculate distance if no map info 
		if @shops.blank? || params[:lat].blank? || params[:lng].blank?
			return
		end

		#calculate distance from search point to each shop
		@shops.each do |shop|
			shop["dist_from_search_point"] = get_distance(
					lng1=longitude.to_d,
					lat1=latitude.to_d,
					lng2=shop["longitude"].to_d,
					lat2=shop["latitude"].to_d
				)
		end

		#sort by distance from search point
		@shops = @shops.sort_by { |shop| shop["dist_from_search_point"].to_d }
	end
end
