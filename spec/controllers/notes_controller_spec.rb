require 'spec_helper'

describe NotesController do
  render_views

  describe "GET 'index'" do

    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user)
    end

    it "should be successful" do
      get :show, :id => @note 
      response.should be_success
    end

    it "should show the content of the note" do
      get :show, :id => @note
      response.should have_selector('span.content', :content => @note.content)
    end

    it "should have a 'back to notebook' link" do
      get :show, :id => @note
      response.should have_selector('a', :href => notebook_path(@notebook), :content => 'back to notebook')
    end

    it "should have an 'edit' link" do
      get :show, :id => @note
      response.should have_selector('a', :href => edit_note_path, :content => 'edit')
    end
  end

end
