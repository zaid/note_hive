class TagsController < ApplicationController
  before_filter :authenticate

  include NotesHelper

  def index
    @title = 'Tag cloud'
    @tags = current_user.notebooks.tag_counts_on(:tags)
    @tags |= current_user.notes.tag_counts_on(:tags)
  end

  def show
    @tag = params[:id]
    @notebooks = current_user.notebooks.tagged_with(params[:id])
    @notes = current_user.notes.tagged_with(params[:id])
  end

end
