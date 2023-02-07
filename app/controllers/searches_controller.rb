class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # 検索対象のmodel
    @model = params[:model]
    # 検索ワード
    @content = params[:content]
    # 検索方法
    @method = params[:method]
    # @model 内が user か book なのかで条件分岐する
    # @records には検索結果が入る　.search_for は各モデルに記述
    if @model == 'user'
      @records = User.search_for(@content,@method)
    else
      @records = Book.search_for(@content,@method)
    end
  end
end