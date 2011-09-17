require 'spec_helper'

describe NotebooksController do
  render_views

  describe "GET 'index'" do

    before(:each) do
      @user = Factory(:user)
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

end
