require 'spec_helper'

describe NotebooksController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = Factory(:user)
    end


    before(:each) do
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should show the user's notebooks" do
      mp1 = Factory(:notebook, :user => @user, :title => 'Foo bar')
      mp2 = Factory(:notebook, :user => @user, :title => 'Baz quux')

      get :index
      response.should have_selector('span.content', :content => mp1.title)
      response.should have_selector('span.content', :content => mp2.title)
    end

    describe "pagination" do
      
      before(:each) do
        @notebooks = []
        30.times do
          @notebooks << Factory(:notebook, :user => @user)
        end
      end

      it "should paginate notebooks" do
        get :index
        response.should have_selector('nav.pagination')
        response.should have_selector('a', :href => '/notebooks?page=2', :content => '2')
        response.should have_selector('a', :href => '/notebooks?page=3', :content => '3')
        response.should have_selector('a', :href => '/notebooks?page=4', :content => '4')
        response.should have_selector('a', :href => '/notebooks?page=5', :content => '5')
      end
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => '' }
      end
      
      it "should not create a notebook" do
        lambda do
          post :create, :notebook => @attr
        end.should_not change(Notebook, :count)
      end 

      it "should render the new template" do
        post :create, :notebook => @attr
        response.should render_template('notebooks/new')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :title => 'Test notebook' }
      end

      it "should create a new instance given valid attributes" do
        lambda do
          post :create, :notebook => @attr
        end.should change(Notebook, :count).by(1)
      end

      it "should redirect to the notebook listing page" do
        post :create, :notebook => @attr
        response.should redirect_to(notebooks_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      session[:user_id] = @user.id
    end

    it "should destroy the notebook" do
      lambda do
        delete :destroy, :id => @notebook
      end.should change(Notebook, :count).by(-1)
    end

    it "should redirect to the home page" do
      delete :destroy, :id => @notebook
      response.should redirect_to(notebooks_path)
    end
  end

  describe "access control" do
    
    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
end
