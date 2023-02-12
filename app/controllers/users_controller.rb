class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @today_book =  @books.where(created_at: Time.zone.now.all_day)
    @yesterday_book = @books.where(created_at: 1.day.ago.all_day)
    @this_week_book = @books.where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day)
    @last_week_book = @books.where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"#①ifで分岐させて空欄なら日付を選択するように表示
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count#②本を投稿した日付を検索し.countで投稿数を取得
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
