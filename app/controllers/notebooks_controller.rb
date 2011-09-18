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
    @notebooks = Notebook.page(params[:page]).per(5)
  end

  def destroy
  end

end
