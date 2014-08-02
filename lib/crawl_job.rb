class CrawlJob < Struct.new(:site_id)
  def perform
    require 'open-uri'
    @site = Site.find(site_id)
    @site.update_attributes(currently_crawling: true, last_crawled: Time.now)
    @links = [@site.url]

    @site.crawling_errors.each { |e| e.destroy }

    crawl_page @site.url
    @site.update_attributes(currently_crawling: false)
  end

  def crawl_page(url, options = {})
    doc = Nokogiri::HTML open(url)
    lorem_results = doc.search "[text()*='digitally']"
    if lorem_results
      lorem_results.each do |lr|
        @site.crawling_errors.create(error_type: 'Lorem ipsum', url: url, info: lr.to_html)
      end
    end

    find_links_on_page(url)
  end

  def find_links_on_page(url)
  end
end
