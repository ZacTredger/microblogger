module ApplicationHelper
  # Returns the full title for a page, or the default, if the page has no name
  def full_title(page_name = '')
    base_title = 'Microblogger'
    return base_title unless page_name&.present?

    page_name + ' | ' + base_title
  end

  def load_feed
    @feed_items = current_user.feed.paginate(page: params[:page])
  end
end
