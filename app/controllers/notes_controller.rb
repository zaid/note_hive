class NotesController < ApplicationController
  before_filter :authenticate
  
  def new
    @title = 'New note'
    @notebook = Notebook.find(params[:notebook_id])
    @note = @notebook.notes.build
  end

  def create
    @notebook = current_user.notebooks.find(params[:notebook_id])
    @note = @notebook.notes.build(params[:note])
    @note.user = current_user

    if @note.save
      flash[:success] = 'Note created!'
      redirect_to @notebook
    else
      render 'notes/new'
    end
  end

  def show
    @notebook = Notebook.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
  end

  def edit
    @title = 'Edit note'
    @notebook = current_user.notebooks.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
  end

  def update
    @notebook = current_user.notebooks.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
    
    if @note.update_attributes(params[:note])
      flash[:success] = 'Note updated'
      redirect_to @notebook
    else
      @title = 'Edit note'
      render 'notes/edit'
    end
  end

  def destroy
    @notebook = Notebook.find(params[:notebook_id])
    @note = @notebook.notes.find(params[:id])
    @note.destroy
    redirect_to @notebook
  end

end
