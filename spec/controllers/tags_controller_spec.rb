require 'spec_helper'
require 'faker'

include ApplicationHelper

describe TagsController do
  render_views

  before(:each) do
    @user = Factory(:user)
    session[:user_id] = @user.id
  end

  describe "GET 'index'" do

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => 'Tag cloud')
    end


    describe "when nothing is tagged" do
      
      it "should show a descriptive message" do
        get :index
        response.should have_selector('p', :content => "You don't have any tagged items yet.")
      end
    end

    describe "when there are tagged notebooks and notes" do
    
      before(:each) do
        @notebooks = []

        2.times do
          @notebooks << Factory(:notebook, :user => @user, :tag_list => Faker::Lorem.words(1).join) 
        end

        @notes = []

        2.times do
          @notes << Factory(:note, :notebook => @notebooks.first, :user => @user, :tag_list => Faker::Lorem.words(1).join)
        end
      end

      it "should show all the tags" do
        get :index

        @notebooks.each do |notebook|
          notebook.tags.each do |tag|
            response.should have_selector('a', :content => tag.name)
          end
        end

        @notes.each do |note|
          note.tags.each do |tag|
            response.should have_selector('a', :content => tag.name)
          end
        end
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @notebooks = []

      12.times do
        @notebooks << Factory(:notebook, :user => @user, :title => Faker::Lorem.words(2).join(' '), :tag_list => 'lorem')
      end
    end

    it "should be successful" do
      get 'show', :id => 'lorem'
      response.should be_success
    end

    describe "for tagged notebooks" do
      
      before(:each) do
        3.times do
          Factory(:notebook, :user => @user, :title => Faker::Lorem.words(2).join(' '), :tag_list => 'ipsum')
        end
      end

      it "should show tagged notebooks" do
        get :show, :id => 'lorem'

        @notebooks[-4, 4].each do |notebook|
          response.should have_selector('span.content', :content => notebook.title)
        end
      end

      it "should paginate notebooks" do
        get :show, :id => 'lorem'
        response.should have_selector('nav.pagination')
        response.should have_selector('a', :href => '/tags/lorem?notebook_page=2', :content => '2')
        response.should have_selector('a', :href => '/tags/lorem?notebook_page=3', :content => '3')
      end
    end

    describe "for tagged notes" do
      
      before(:each) do
        @notes = []
        
        12.times do
          @notes << Factory(:note, :notebook => @notebooks.first, :user => @user, :content => Faker::Lorem.sentences.join(' '), :tag_list => 'lorem')
        end

        2.times do
          Factory(:note, :notebook => @notebooks.last, :user => @user, :content => Faker::Lorem.sentences.join(' '), :tag_list => 'ipsum')
        end
      end

      it "should show tagged notes" do
        get :show, :id => 'lorem'

        @notes[-4, 4].each do |note|
          response.should have_selector('span.content', :content => shorten_text(note.content))
        end
      end
      
      it "should paginate notes" do
        get :show, :id => 'lorem'
        response.should have_selector('nav.pagination')
        response.should have_selector('a', :href => '/tags/lorem?note_page=2', :content => '2')
        response.should have_selector('a', :href => '/tags/lorem?note_page=3', :content => '3')
      end
    end
  end
end
