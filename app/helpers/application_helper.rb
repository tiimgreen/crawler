module ApplicationHelper
  def full_title(title, base = 'Crawler')
    (title.empty? ? base : "#{title} | #{base}").html_safe
  end
end
