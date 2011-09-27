require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector('title', :content => 'Sign up')
    end
  end

  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => '', :email => '', :password => '', :password_confirmation => '' }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => 'Sign up')
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :name => 'New User', :email => 'user@example.ca', :password => 'foobar', :password_confirmation => 'foobar' }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should log the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

      it "should redirect to the home page" do
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to notehive/i
      end
    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => 'Profile')
    end

    it "should show the user's name and email" do
      get :show, :id => @user
      response.should have_selector('td', :content => @user.name)
      response.should have_selector('td', :content => @user.email)
    end

    it "should have an 'edit profile' link" do
      get :show, :id => @user
      response.should have_selector('a', :href => edit_user_path(@user), :content => 'Edit profile')
    end 
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => 'Edit profile')
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    describe "failure" do

      before(:each) do
        @attr = { :name => @user.name, :email => @user.email, :password => '', :password_confirmation => '' }
      end

      it "should render the edit profile page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('users/edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => 'Edit profile')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :name => 'John doe', :email => 'jdoe@example.ca', :password => 'secret', :password_confirmation => 'secret' }
      end

      it "should update the user profile" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user profile page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to user_path(@user)
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /profile updated/i
      end
    end
  end

  describe "access control" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should deny access to the profile page" do
      get :show, :id => @user
      response.should redirect_to(signin_path)
    end

    it "should deny access to the edit profile page" do
      get :edit, :id => @user
      response.should redirect_to(signin_path)
    end

    it "should deny access to the update action" do
      put :update, :id => @user
      response.should redirect_to(signin_path)
    end
  end

  describe "authentication of edit/update actions" do
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => 'wrong_user@example.ca')
        session[:user_id] = wrong_user.id
      end

      it "should require matching users for edit" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
