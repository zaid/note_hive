require 'spec_helper'

describe Notebook do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :title => 'Scribbling notebook' }
  end

  it "should create a new instance given valid attributes" do
    @user.notebooks.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @notebook = @user.notebooks.create!(@attr)
    end

    it "should have a user attribute" do
      @notebook.should respond_to(:user)
    end

    it "should have the right associated user" do
      @notebook.user_id.should == @user.id
      @notebook.user.should == @user
    end
  end

  describe "note associations" do
    
    before(:each) do
      @note_attr = { :content => 'Foo bar' }
      @notebook = Factory(:notebook, :user => @user)
      @note = @notebook.notes.build(@note_attr)
    end

    it "should have a notes attribute" do
      @notebook.should respond_to(:notes)
    end

    it "should have the right associated note" do
      @notebook.notes.first.id.should == @note.id
      @notebook.notes.first.should == @note
    end
  end

  describe "validations" do
    
    it "should require a user id" do
      Notebook.new(@attr).should_not be_valid  
    end

    it "should require a non-blank title" do
      @user.notebooks.build(:title => '    ').should_not be_valid
    end

    it "should reject a long title" do
      long_title = 'a' * 81
      @user.notebooks.build(:title => long_title).should_not be_valid
    end
  end
end
