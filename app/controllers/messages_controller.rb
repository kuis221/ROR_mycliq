class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @chosen_recipient = User.find_by(id: params[:to].to_i) if params[:to]
  end

  def create
    if !params["recipients"]
      redirect_to :back, notice: "Select recipients"
    else
      recipients = User.where(username: params["recipients"].map { |p| p.split.last.gsub(/^\(+|\)+$/, "") })
      conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
      flash[:success] = "Message has been sent!"
      redirect_to conversation_path(conversation)
    end
  end
end
