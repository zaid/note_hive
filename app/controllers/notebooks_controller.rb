class NotebooksController < ApplicationController
  before_filter :authenticate
  before_filter :get_notebook, :only => [:show, :edit, :update, :destroy]

  include NotesHelper

  respond_to :html, :js

  def new
    @title = 'New notebook'
    @notebook = current_user.notebooks.new if signed_in?
  end

  def create
    @notebook = current_user.notebooks.build(params[:notebook])
    if @notebook.save
      flash[:success] = 'Notebook created!'
      redirect_to notebooks_path
    else
      render 'notebooks/new'
    end
  end

  def index
    @search = current_user.notebooks.search(params[:q])
    @notebooks = @search.result(:distinct => true).page(params[:page]).per(8)
    respond_with @notebooks
  end

  def show
    @notes = @notebook.notes.page(params[:page]).per(8)
    respond_with @notes
  end

  def edit
    @title = 'Edit notebook'
  end

  def update
    if @notebook.update_attributes(params[:notebook])
      flash[:success] = 'Notebook updated'
      redirect_to @notebook
    else
      @title = 'Edit notebook'
      render 'notebooks/edit'
    end
  end

  def destroy
    @notebook.destroy
    redirect_to notebooks_path
  end

  private

  def get_notebook
    @notebook = current_user.notebooks.find(params[:id])
  end
end
