class StaticPagesController < ApplicationController
  def home
    return (@sample_user = User.first) unless logged_in?

    @post = current_user.posts.build
    load_feed
  end

  def help; end

  def about; end

  def contact; end
end
