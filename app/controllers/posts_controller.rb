class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created'
      redirect_to root_url
    else
      load_feed
      render 'static_pages/home'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post deleted'
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content, :picture)
  end

  # Before filters
  # Confirm requesting user is the post's owner
  def correct_user
    @post = Post.find_by(id: params[:id])
    return super(user_id: @post.user_id) if @post

    flash[:danger] = 'Post does not exist!'
    redirect_to root_path
  end
end
