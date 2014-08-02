class CrawlJob < Struct.new(:site_id)
  def perform
    site = Site.find site_id
  end
end
