class BookmarksController < ApplicationController

	before_action :authenticate_user

	def index
		bookmarks = Bookmark.where(user_id: @current_user.id).pluck("shop_id")
		@shops = get_restaurants_info_from_id(bookmarks)

		if @shops.blank?
			return
		end

		shop_ids = @shops.map{|shop| shop["id"]}
		#one-shot api request to avoid throwing request each loop
		scores = get_scores(shop_ids)
		
		@shops.each do |shop|
			shop["score"] = scores["#{shop['id']}"]
		end
	end

	def create
		@bookmark = Bookmark.new(
			user_id: @current_user.id,
			shop_id: params[:shop_id]
		)
		@bookmark.save

		redirect_to root_path
	end

	def destroy
		@bookmark = Bookmark.find_by(
			user_id: @current_user.id,
			shop_id: params[:shop_id]
		)

		@bookmark.destroy
		
		redirect_to root_path
	end

end
