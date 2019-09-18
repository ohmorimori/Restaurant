class ShopsController < ApplicationController
	include Common
	def index
		shops = get_restaurants_info(
				search_word=params[:search],
				latitude=params[:lat],
				longitude=params[:lng]
			)

		@shops = add_distance_info(
				shops=shops,
				latitude=params[:lat],
				longitude=params[:lng]
			)
	end
end
