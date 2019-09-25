class Bookmark < ApplicationRecord
	validates :user_id, {presence: true}
	validates :shop_id, {presence: true}
end
