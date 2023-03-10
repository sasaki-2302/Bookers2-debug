class TagSearchesController < ApplicationController

  def search
    @model = Book
    @content = params[:content]
    @method
    @records = Book.where("tag LIKE?","%#{@content}%")
    render "serches/result"
  end
end
