class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @newbook = Book.new
    @book_comment = BookComment.new
    @user = @book.user
    @book_tag = @book.tags
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end


  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to - 1.week).at_beginning_of_day
    if params[:sort] == "newArrival"
      @books = Book.order(created_at: :desc)
    elsif params[:sort] == "evaluation"
      @books = Book.order(evaluation: :desc)
    else
      @books = Book.includes(:favorited_users).where(created_at: from...to).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @tag_list = params[:book][:tag_name].split(nil)
    if @book.save
      @book.save_tag(@tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:tag_name).join(" ")
    if @book.user != current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:tag_name].split(nil)
    if @book.update(book_params)
      @book.save_tag(tag_list)
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

  def search
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books.all
    @book = Book.new
  end


  private
  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end

end
