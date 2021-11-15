class BookCommentsController < ApplicationController

  def create
		@book = Book.find(params[:book_id])
		@book_comment = BookComment.new(comment_params)
		@book_comment.book_id = @book.id
		@book_comment.user_id = current_user.id
		@book_comment.save
  end

  def destroy
    @book = Book.find(params[:book_id])
  	BookComment.find_by(id: params[:id]).destroy
		@newbook = Book.new
    @book_comment = BookComment.new
  end

  private
  def comment_params
    params.require(:book_comment).permit(:comment)
  end

end
