class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]

  def new
    @title = 'Sign up'
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'Welcome to NoteHive!'
      redirect_to root_path
    else
      @title = 'Sign up'
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @title = 'Edit profile'
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      @title = 'Edit profile'
      render 'edit'
    end
  end

end
