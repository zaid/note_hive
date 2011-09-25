class NotesController < ApplicationController
  before_filter :authenticate
  before_filter :get_notebook
  
  def new
    @title = 'New note'
    @note = @notebook.notes.build
  end

  def create
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
    @note = @notebook.notes.find(params[:id])
  end

  def edit
    @title = 'Edit note'
    @note = @notebook.notes.find(params[:id])
  end

  def update
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
    @note = @notebook.notes.find(params[:id])
    @note.destroy
    redirect_to @notebook
  end

  private

  def get_notebook
    @notebook = current_user.notebooks.find(params[:notebook_id])
  end

end
