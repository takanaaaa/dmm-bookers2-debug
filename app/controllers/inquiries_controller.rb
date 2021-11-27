class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
  end

  def create
    inquiry = Inquiry.new(inquiry_params)
    inquiry.user_id = current_user.id
    group = Group.find(params[:id])
    if inquiry.save
      users = group.users
      title = inquiry.title
      content = inquiry.content
      UserMailer.send_event_mail(users, title, content)
      redirect_to inquiry_path(inquiry)
    else
      render :new
    end
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  private
  def inquiry_params
    params.require(:inquiry).permit(:title, :content)
  end
end
