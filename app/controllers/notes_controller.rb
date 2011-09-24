class NotesController < ApplicationController

  def show
    @note = Note.find(params[:id])
  end

  def destroy
    @note = Note.find(params[:id])
    notebook = @note.notebook
    @note.destroy
    redirect_to notebook
  end

end
