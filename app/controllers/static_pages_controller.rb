class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @post = current_user.posts.build
    load_feed
  end

  def help; end

  def about; end

  def contact; end
end
