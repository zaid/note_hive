class TagsController < ApplicationController
  before_filter :authenticate

  include NotesHelper

  def show
    @tag = params[:id]
    @notebooks = current_user.notebooks.tagged_with(params[:id])
    @notes = current_user.notes.tagged_with(params[:id])
  end

end
