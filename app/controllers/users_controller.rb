class UsersController < ApplicationController
	include Common
	
	before_action :authenticate_user, {only: [:show, :edit, :update, :logout]}
	before_action :restrict_current_user, {only: [:login, :login_form, :new, :create]}
	before_action :ensure_correct_user, {only: [:edit, :show, :update]}
	
	def new
		@user = User.new
	end
	
	def show
		@user = User.find_by(id: params[:id])
	end
	
	def create
		@user = User.new(user_params)

		if @user.save
			flash[:notice]  = "Signed up!"
			session[:user_id] = @user.id
			redirect_to user_path(@user)
		else
			render 'new'
		end
	end

	def edit
		@user = User.find_by(id: params[:id])
	end

	def update
		@user =  User.find_by(id: params[:id])
		if @user.update_attributes(user_params)
			flash[:notice] = "Account information updated"
			redirect_to user_path(@user)
		else
			render 'edit'
		end
		
	end

	def login_form
		#@user = User.new
	end

	def login
		@user = User.find_by(email: params[:email])

		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			flash[:notice] = "Login Succeeded"
			redirect_to root_path
		else
			@error_message = "email or password is wrong"
			@email = params[:email]
			@password = params[:password]
			render 'login_form'
		end
	end

	def logout
		session[:user_id] = nil
		flash[:notice] = "Logged out"
		redirect_to login_path
	end


private
	def user_params
		params.require(:user).permit(:name, :email, :password)
	end

end
