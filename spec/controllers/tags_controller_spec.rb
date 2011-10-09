require 'spec_helper'
require 'faker'

describe TagsController do
  render_views

  before(:each) do
    @user = Factory(:user)
    session[:user_id] = @user.id
  end

  describe "GET 'show'" do

    before(:each) do
      @notebooks = []

      2.times do
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

        @notebooks.each do |notebook|
          response.should have_selector('span.content', :content => notebook.title)
        end
      end
    end

    describe "for tagged notes" do
      
      before(:each) do
        @notes = []
        
        2.times do
          @notes << Factory(:note, :notebook => @notebooks.first, :user => @user, :content => Faker::Lorem.sentences.join(' '), :tag_list => 'lorem')
        end

        2.times do
          Factory(:note, :notebook => @notebooks.last, :user => @user, :content => Faker::Lorem.sentences.join(' '), :tag_list => 'ipsum')
        end
      end

      it "should show tagged notes" do
        get :show, :id => 'lorem'

        @notes.each do |note|
          response.should have_selector('span.content', :content => controller.make_title(note.content))
        end
      end
    end
  end
end
