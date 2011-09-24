class NotesController < ApplicationController
  before_filter :authenticate

  def show
    @notebook = Notebook.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
  end

  def destroy
    @notebook = Notebook.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
    @note.destroy
    redirect_to @notebook
  end

end
