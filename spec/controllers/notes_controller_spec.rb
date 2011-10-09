require 'spec_helper'
require 'faker'

describe NotesController do
  render_views

  describe "GET 'new'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :new, :notebook_id => @notebook
      response.should be_success
    end

    it "should have the right title" do
      get :new, :notebook_id => @notebook
      response.should have_selector('title', :content => 'New note')
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      session[:user_id] = @user.id
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :content => '' }
      end

      it "should not create a note" do
        lambda do
          post :create, :notebook_id => @notebook, :note => @attr
        end.should_not change(Note, :count)
      end

      it "should render the new template" do
        post :create, :notebook_id => @notebook, :note => @attr
        response.should render_template('notes/new')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :content => Faker::Lorem.sentences(20).join }
      end

      it "should create a new instance given valid attributes" do
        lambda do
          post :create, :notebook_id => @notebook, :note => @attr
        end.should change(Note, :count).by(1)
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user, :tag_list => 'lorem, ipsum')
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :show, :notebook_id => @notebook, :id => @note
      response.should be_success
    end

    it "should show the content of the note" do
      get :show, :notebook_id => @notebook, :id => @note
      response.should have_selector('div.note', :content => @note.content)
    end

    it "should have a 'back to notebook' link" do
      get :show, :notebook_id => @notebook, :id => @note
      response.should have_selector('a', :href => notebook_path(@notebook), :content => 'back to notebook')
    end

    it "should have an 'edit' link" do
      get :show, :notebook_id => @notebook, :id => @note
      response.should have_selector('a', :href => edit_notebook_note_path(@notebook, @note), :content => 'edit')
    end

    it "should show the note's tags" do
      get :show, :notebook_id => @notebook, :id => @note

      @note.tags.each do |tag|
        response.should have_selector('a', :href => tag_path(tag.name), :content => tag.name)
      end
    end
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :edit, :notebook_id => @notebook, :id => @note
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :notebook_id => @notebook, :id => @note
      response.should have_selector('title', :content => 'Edit note')
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user)
      session[:user_id] = @user.id
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :content => '' }
      end

      it "should render the edit page" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        response.should render_template('notes/edit')
      end

      it "should have the right title" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        response.should have_selector('title', :content => 'Edit note')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :content => Faker::Lorem.sentences(15).join, :tag_list => ['lorem', 'ipsum'] }
      end

      it "should change the note's content" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        @note.reload
        @note.content.should == @attr[:content]
      end

      it "should redirect to the note listing page" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        response.should redirect_to(notebook_path(@notebook))
      end

      it "should show a flash message" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        flash[:success].should =~ /note updated/i
      end

      it "should change the note's tags" do
        put :update, :notebook_id => @notebook, :id => @note, :note => @attr
        @note.reload
        @note.tag_list.should == @attr[:tag_list]
      end
    end
  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user)
      session[:user_id ] = @user.id
    end

    it "should destroy the note" do
      lambda do
        delete :destroy, :notebook_id => @notebook, :id => @note
      end.should change(Note, :count).by(-1)
    end

    it "should redirect to the notes listing page" do
      delete :destroy, :notebook_id => @notebook, :id => @note
      response.should redirect_to notebook_path(@notebook)
    end
  end

  describe "access control" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      @note = Factory(:note, :notebook => @notebook, :user => @user)
    end

    it "should deny access to 'show'" do
      get :show, :notebook_id => @notebook, :id => @note
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :notebook_id => @notebook, :id => @note
      response.should redirect_to(signin_path)
    end
  end
end
