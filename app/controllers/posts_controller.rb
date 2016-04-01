class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy, :remove_photo]

  def create
    params[:post].delete(:photo) if params[:post][:remove_image] != "1"
    @post = current_user.posts.new(post_params)
    if @post.save
      @post.create_activity key: 'post.created', owner: @post.user
      respond_to do |format|
        format.html {redirect_to :back, notice: "Post Created"}
      end
    else
      redirect_to :back, notice: @post.errors.full_messages.join(", ")
    end
  end

  def edit
  end

  def update
    params[:post].delete(:photo) if params[:post][:remove_image] != "1"
    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to user_path(@post.user.username), notice: "Post Updated" }
      end
    else
      redirect_to post_path(@post), notice: "Something went wrong"
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to user_path(@post.user.username), notice: "Post Destroyed" }
    end
  end

  def remove_photo
    @notice = "Post photo has been removed" unless @post.photo.blank?
    @post.photo = nil
    @post.save
    redirect_to :back, notice: @notice
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :photo)
  end
end
