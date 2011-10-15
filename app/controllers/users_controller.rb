class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :except => [:new, :create]

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
    @title = 'Profile'
  end

  def edit
    @title = 'Edit profile'
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      @title = 'Edit profile'
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to(root_path)
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user == @user
    end

end
