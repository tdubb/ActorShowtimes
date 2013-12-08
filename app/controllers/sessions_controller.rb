class SessionsController < ApplicationController

	def new
	end

	def create
	  user = User.find_by(email: params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    if user
      sign_in user
      redirect_to root_path
    else
      redirect_to signin_path
      flash[:notice] = 'Invalid email/password combination'
    end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

  # def create
  #   email = params[:email_address]
  #   user = User.find_by_email(email)
  #   unless user
  #     redirect_to signin_path
  #     flash[:notice] = "Please enter an existing user's email"
  #   else
  #     session[:current_user_id] = user.id
  #     flash[:notice] = "You have successfully logged in!"
  #     redirect_to root_url
  #   end
  # end

  # def destroy
  #   @_current_user = session[:current_user_id] = nil
  #   flash[:notice] = "You have successfully logged out."
  #   redirect_to root_url
  # end

end
