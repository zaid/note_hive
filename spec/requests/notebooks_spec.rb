require 'spec_helper'

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
          visit root_path
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
          visit root_path
          fill_in :notebook_title, :with => 'Foo bar'
          click_button
          response.should have_selector('span.content', :content => 'Foo bar')
        end.should change(Notebook, :count).by(1)
      end
    end
  end
end
