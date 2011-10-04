require 'spec_helper'
require 'faker'

describe Note do
  
  before(:each) do
    @user = Factory(:user)
    @notebook = Factory(:notebook, :user => @user)
    @attr = { :content => 'Foo bar' }
  end
  
  describe "validations" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :content => '' }
      end
      
      it "should require a non-blank title" do
        Note.new(@attr).should_not be_valid
      end

      it "should require a user" do
        note = Factory.build(:note, :notebook => @notebook, :user => nil)
        note.should_not be_valid
      end

      it "should require a notebook" do
        note = Factory.build(:note, :user => @user, :notebook => nil)
        note.should_not be_valid
      end
    end

    describe "success" do
      
      it "should create a new instance given valid attributes" do
        note = Factory.build(:note, :notebook => @notebook, :user => @user)
        note.should be_valid
      end
    end
  end

  describe "user associations" do
    
    before(:each) do
      @note = @user.notes.build(@attr)
    end

    it "should have a user attribute" do
      @note.should respond_to(:user)  
    end

    it "should have the right associated user" do
      @note.user_id.should == @user.id
      @note.user.should == @user
    end
  end

  describe "notebook associations" do
    
    before(:each) do
      @notebook = Factory(:notebook, :user => @user)
      @note = @notebook.notes.build(@attr)
    end

    it "should have a notebook attribute" do
      @note.should respond_to(:notebook)
    end

    it "should have the right associated notebook" do
      @note.notebook_id.should == @notebook.id
      @note.notebook.should == @notebook
    end
  end

  describe "tagging" do

    before(:each) do
      @note1 = Factory(:note, :user => @user, :notebook => @notebook, :content => Faker::Lorem.sentences(5).join)
      @note2 = Factory(:note, :user => @user, :notebook => @notebook, :content => Faker::Lorem.sentences(5).join)
      @note3 = Factory(:note, :user => @user, :notebook => @notebook, :content => Faker::Lorem.sentences(5).join)
    end

    it "should have a 'tags' attribute" do
      @note1.should respond_to(:tags)
    end

    it "should find tagged notebooks" do
      @note1.tag_list = 'lorem, random'
      @note1.save

      @note3.tag_list = 'lorem'
      @note3.save

      lorem_notes = Note.tagged_with('lorem')
      lorem_notes.count.should == 2

      lorem_notes.find(@note1.id).should == @note1
      lorem_notes.find(@note3.id).should == @note3
    end
  end
end
