module ApplicationHelper
  # Returns the full title for a page, or the default, if the page has no name
  def full_title(page_name = '')
    base_title = 'Microblogger'
    return base_title if page_name.empty?

    page_name + ' | ' + base_title
  end
end
