class NotebooksController < ApplicationController

  def create
    @notebook = current_user.notebooks.build(params[:notebook])
  end

  def index
    @notebooks = Notebook.page(params[:page]).per(5)
  end

end
