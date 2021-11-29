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
      @books = Book.left_joins(:tag_maps).where(:tag_maps => {:tag_id => tag.ids})
    end
  end
end
