class NotesController < ApplicationController

  def show
    @notebook = Notebook.find(params[:notebook_id])
    @note = Note.find(params[:id])
  end

  def destroy
    @note = Note.find(params[:id])
    @notebook = Notebook.find(params[:notebook_id])
    @note.destroy
    redirect_to @notebook
  end

end
