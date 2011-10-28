require 'spec_helper'
require 'faker'

include ApplicationHelper

describe "Notes" do
  
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "creation" do

    before(:each) do
      @notebook = Factory(:notebook, :user => @user)
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :content => '' }
      end

      it "should not make a new note" do
        lambda do
          visit notebook_path(@notebook)
          click_link 'new note'
          fill_in :note_content, :with => @attr[:content]
          click_button
        end.should_not change(Note, :count)
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :content => Faker::Lorem.sentences(20).join, :tag_list => 'lorem, ipsum' }
      end

      it "should make a new note" do
        lambda do
          visit notebook_path(@notebook)
          click_link 'new note'
          fill_in :note_content, :with => @attr[:content]
          click_button
        end.should change(Note, :count).by(1)
      end

      it "should make a new note with tags" do
        lambda do
          visit notebook_path(@notebook)
          click_link 'new note'
          fill_in :note_content, :with => @attr[:content]
          fill_in :note_tag_list, :with => @attr[:tag_list]
          click_button

          note = @user.notes.first
          visit notebook_note_path(@notebook, note)

          note.tags.each do |tag|
            response.should have_selector('a', :href => tag_path(tag.name), :content => tag.name)
          end
        end.should change(Note, :count).by(1)
      end
    end
  end

  describe "listing" do
    
    before(:each) do
      @notebook = Factory(:notebook, :user => @user)
      @notes = []
      5.times do
        @notes << Factory(:note, :notebook => @notebook, :user => @user, :content => Faker::Lorem.sentences(20).join)
      end
    end

    it "should show a note listing" do
      visit notebook_path(@notebook)
      @notes.each do |note|
        response.should have_selector('span.content', :content => controller.shorten_text(note.content))
      end
    end
    
    it "should have a show link for each note" do
      visit notebook_path(@notebook)
      @notes.each do |note|
        response.should have_selector('a', :href => notebook_note_path(@notebook, note), :content => 'show')
      end
    end

    it "should have an edit link for each note" do
      visit notebook_path(@notebook)
      @notes.each do |note|
        response.should have_selector('a', :href => edit_notebook_note_path(@notebook, note), :content => 'edit')
      end
    end

    it "should have a delete link for each note" do
      visit notebook_path(@notebook)
      @notes.each do |note|
        response.should have_selector('a', :href => notebook_note_path(@notebook, note), :content => 'delete')
      end
    end
  end
end
