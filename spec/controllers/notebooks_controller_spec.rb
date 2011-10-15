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
      nb1 = Factory(:notebook, :user => @user, :title => 'Foo bar')
      nb2 = Factory(:notebook, :user => @user, :title => 'Baz quux')

      get :index
      response.should have_selector('span.content', :content => nb1.title)
      response.should have_selector('span.content', :content => nb2.title)
    end

    it "should show the last updated timestamp for each user's notebook" do
      nb = Factory(:notebook, :user => @user, :title => 'A notebook')

      get :index
      response.should have_selector('span.timestamp', :content => "Last updated ")

    end

    it "should show the 'show' link for each user's notebook'" do
      nb1 = Factory(:notebook, :user => @user, :title => 'First notebook')
      nb2 = Factory(:notebook, :user => @user, :title => 'Second notebook')

      get :index
      response.should have_selector('a', :href => notebook_path(nb1), :content => 'show')
      response.should have_selector('a', :href => notebook_path(nb2), :content => 'show')
    end

    it "should show the 'edit' link for each user's notebook'" do
      nb1 = Factory(:notebook, :user => @user, :title => 'First notebook')
      nb2 = Factory(:notebook, :user => @user, :title => 'Second notebook')

      get :index
      response.should have_selector('a', :href => edit_notebook_path(nb1), :content => 'edit')
      response.should have_selector('a', :href => edit_notebook_path(nb2), :content => 'edit')
    end

    it "should show the 'delete' link for each user's notebook'" do
      nb1 = Factory(:notebook, :user => @user, :title => 'First notebook')
      nb2 = Factory(:notebook, :user => @user, :title => 'Second notebook')

      get :index
      response.should have_selector('a', :href => notebook_path(nb1), :content => 'delete')
      response.should have_selector('a', :href => notebook_path(nb2), :content => 'delete')
    end

    describe "pagination" do
      
      before(:each) do
        @notebooks = []
        30.times do
          notebook = Factory(:notebook, :user => @user)
          @notebooks << notebook 
          30.times do
            notebook.notes << Factory(:note, :notebook => notebook, :user => @user) 
          end
        end
      end

      it "should paginate notebooks" do
        get :index
        response.should have_selector('nav.pagination')
        response.should have_selector('a', :href => '/notebooks?page=2', :content => '2')
        response.should have_selector('a', :href => '/notebooks?page=3', :content => '3')
        response.should have_selector('a', :href => '/notebooks?page=4', :content => '4')
      end

      it "should paginate notes" do
        notebook = @notebooks.first
        get :show, :id => notebook 
        response.should have_selector('nav.pagination')
        response.should have_selector('a', :href => notebook_path(notebook) +'?page=2', :content => '2')
        response.should have_selector('a', :href => notebook_path(notebook) +'?page=3', :content => '3')
        response.should have_selector('a', :href => notebook_path(notebook) +'?page=4', :content => '4')
      end
    end
  end

  describe "GET 'new'" do
    
    before(:each) do
      @user = Factory(:user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => 'New notebook')
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

    it "should deny access to 'show'" do
      get :show, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook1 = Factory(:notebook, :user => @user, :title => 'Foo bar', :tag_list => 'lorem, ipsum')
      @notebook2 = Factory(:notebook, :user => @user, :title => 'Bar foo')
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :show, :id => @notebook1
      response.should be_successful
    end

    it "should show the right notebook" do
      get :show, :id => @notebook1
      assigns(:notebook).id.should == @notebook1.id
      assigns(:notebook).should == @notebook1
    end

    it "should show the notebook's notes" do
      note1 = Factory(:note, :notebook => @notebook1, :user => @user, :content => 'Foo bar')
      note2 = Factory(:note, :notebook => @notebook1, :user => @user, :content => 'Bar foo')

      get :show, :notebook_id => @notebook, :id => @notebook1
      response.should have_selector('span.content', :content => note1.content)
      response.should have_selector('span.content', :content => note2.content)
    end

    it "should show the last updated time for each note in the notebook" do
      note = Factory(:note, :notebook => @notebook1, :user => @user, :content => 'Foo bar')

      get :show, :notebook_id => @notebook, :id => @notebook1
      response.should have_selector('span.timestamp', :content => 'Last updated ')
 
    end

    it "should have a 'new note' link" do
      get :show, :notebook_id => @notebook, :id => @notebook1
      response.should have_selector('a', :href => new_notebook_note_path(@notebook1), :content => 'new note')
    end

    it "should have an 'edit' link" do
      get :show, :id => @notebook1
      response.should have_selector('a', :href => edit_notebook_path(@notebook1), :content => 'edit')
    end

    it "should show a list of tags for the notebook" do
      get :show, :id => @notebook1

      @notebook1.tags.each do |tag|
        response.should have_selector('a', :href => tag_path(tag.name), :content => tag.name)
      end
    end
  end

  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      session[:user_id] = @user.id
    end

    it "should be successful" do
      get :edit, :id => @notebook
    end

    it "should have the right title" do
      get :edit, :id => @notebook
      response.should have_selector('title', :content => 'Edit notebook')
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      @notebook = Factory(:notebook, :user => @user)
      session[:user_id] = @user.id
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :title => '' }
      end

      it "should render the edit page" do
        put :update, :id => @notebook, :notebook => @attr
        response.should render_template('notebooks/edit')
      end

      it "should have the right title" do
        put :update, :id => @notebook, :notebook => @attr
        response.should have_selector('title', :content => 'Edit notebook')
      end

    end

    describe "success" do
      
      before(:each) do
        @attr = { :title => 'New updated title!', :tag_list => ['magic'] }
      end

      it "should update the notebook's title" do
        put :update, :id => @notebook, :notebook => @attr
        @notebook.reload
        @notebook.title.should == @attr[:title]
      end

      it "should redirect to the note listing page" do
        put :update, :id => @notebook, :notebook => @attr
        response.should redirect_to notebook_path(@notebook)
      end
      
      it "should show a flash message" do
        put :update, :id => @notebook, :notebook => @attr
        flash[:success].should =~ /notebook updated/i
      end
      
      it "should update the notebook's tags" do
        put :update, :id => @notebook, :notebook => @attr
        @notebook.reload
        @notebook.tag_list.should == @attr[:tag_list]
      end
    end
  end
end
