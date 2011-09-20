class NotebooksController < ApplicationController
  before_filter :authenticate

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

  def destroy
    @notebook = Notebook.find(params[:id])
    @notebook.destroy
    redirect_to notebooks_path
  end

end
