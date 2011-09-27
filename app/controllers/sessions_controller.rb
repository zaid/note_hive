class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid email or password'
      @title = 'Sign in'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => 'Logged out!'
  end

end
