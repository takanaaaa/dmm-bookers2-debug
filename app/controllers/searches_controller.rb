class SearchesController < ApplicationController

  def search
    @range = params[:range]
    search = params[:search]
    word = params[:word]

    if @range == '1'
      @user = User.search(search, word)
    elsif @range == '2'
      @book = Book.search(search, word)
    else
      tag = Tag.search(search, word)
      redirect_to tag_book_path(tag.ids)
    end
  end
end
