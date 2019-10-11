class ApplicationController < ActionController::Base
	include Common
	before_action :set_current_user
end
