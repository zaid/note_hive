require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => 'Home')
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => 'About')
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => 'Contact')
  end

  it "should have a Sign up page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => 'Sign up')
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link 'About'
    response.should have_selector('title', :content => 'About')
    click_link 'Contact'
    response.should have_selector('title', :content => 'Contact')
    click_link 'Home'
    response.should have_selector('title', :content => 'Home')
    click_link 'Sign up now!'
    response.should have_selector('title', :content => 'Sign up')
  end

  describe "when not signed in" do
    
    it "should have a signin link" do
      visit root_path
      response.should have_selector('a', :href => signin_path, :content => 'Sign in')
    end

    it "should have a signup link on the home page" do
      visit root_path
      response.should have_selector('a', :href => signup_path, :content => 'Sign up')
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_button
    end
    
    it "should have a signout link" do
      visit root_path
      response.should have_selector('a', :href => signout_path, :content => 'Sign out')
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector('a', :href => user_path(@user), :content => 'Profile')
    end

    it "should have a notebooks link" do
      visit root_path
      response.should have_selector('a', :href => notebooks_path, :content => 'Notebooks')
    end

    it "should have a notebook creation form" do
      visit root_path
      response.should have_selector('input', :id => 'notebook_title')
    end
  end
end
