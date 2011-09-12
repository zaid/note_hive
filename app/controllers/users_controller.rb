class UsersController < ApplicationController

  def new
    @title = 'Sign up'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = 'Welcome to NoteHive!'
      redirect_to @user
    else
      @title = 'Sign up'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
