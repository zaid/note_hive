class NotebooksController < ApplicationController
  before_filter :authenticate

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
    @notebooks = current_user.notebooks.page(params[:page]).per(8)
  end

  def show
    @notebook = current_user.notebooks.find(params[:id])
    @notes = @notebook.notes.page(params[:page]).per(8)
  end

  def edit
    @title = 'Edit notebook'
    @notebook = current_user.notebooks.find(params[:id])
  end

  def update
    @notebook = current_user.notebooks.find(params[:id])

    if @notebook.update_attributes(params[:notebook])
      flash[:success] = 'Notebook updated'
      redirect_to @notebook
    else
      @title = 'Edit notebook'
      render 'notebooks/edit'
    end
  end

  def destroy
    @notebook = Notebook.find(params[:id])
    @notebook.destroy
    redirect_to notebooks_path
  end

end
