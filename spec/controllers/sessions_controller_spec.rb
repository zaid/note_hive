require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    
    describe "invalid signin" do
      
      before(:each) do
        @attr = { :email => 'user@example.ca', :password => 'foobar' }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector('title', :content => 'Sign in')
      end

      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end

    describe "with valid email and password" do
      
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :email => @attr[:email], :password => @attr[:password]
        controller.should be_signed_in
      end

      it "should redirect to the home page" do
        post :create, :email => @attr[:email], :password => @attr[:password]
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      user = Factory(:user)
      post :create, :email => user.email, :password => user.password
    end

    it "should sign a user out" do
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
