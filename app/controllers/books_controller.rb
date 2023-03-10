class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @book_comment = BookComment.new
    impressionist(@book,nil, :unique => [:session_hash.to_s])
  end

  def index
    @now = Time.current
    # 1週間を定義
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day

    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:rate_count]
      @books = Book.rate_count
    elsif params[:favorite_count]
      # Bookモデルより全データを取得、1週間のいいね数で降順で並び替える
      @books = Book.all.sort {|a,b| b.favorite.where(created_at: from...to).size <=> a.favorite.where(created_at: from...to).size}
    else
      @books = Book.all
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    user_id = @book.user_id
    unless user_id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    user_id = @book.user_id
    unless user_id == current_user.id
      redirect_to books_path
    end

    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:body, :title, :rate, :tag)
  end
end
