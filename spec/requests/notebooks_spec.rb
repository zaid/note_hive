require 'spec_helper'
require 'faker'

describe "Notebooks" do
  
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "creation" do
    
    describe "failure" do
      
      it "should not make a new notebook" do
        lambda do
          visit notebooks_path
          click_link 'new notebook'
          fill_in :notebook_title, :with => ''
          click_button
          response.should render_template('notebooks/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(Notebook, :count)
      end
    end

    describe "success" do
      
      it "should make a new notebook" do
        lambda do
          visit notebooks_path
          click_link 'new notebook'
          fill_in :notebook_title, :with => 'Foo bar'
          click_button
          response.should have_selector('span.content', :content => 'Foo bar')
        end.should change(Notebook, :count).by(1)
      end
    end
  end

  describe "listing" do

    before(:each) do
      @notebooks = []
      5.times do
        @notebooks << Factory(:notebook, :user => @user, :title => Faker::Lorem.sentence(2))
      end
    end

    it "should show a notebook listing" do
      visit notebooks_path
      @notebooks.each do |notebook|
        response.should have_selector('span.content', :content => notebook.title)
      end
    end

    it "should have a delete link for each notebook" do
      visit notebooks_path
      @notebooks.each do |notebook|
        response.should have_selector('a', :href => notebook_path(notebook), :content => 'delete')
      end
    end

    it "should have a show link for each notebook" do
      visit notebooks_path
      @notebooks.each do |notebook|
        response.should have_selector('a', :href => notebook_path(notebook), :content => 'show')
      end
    end
  end
end
