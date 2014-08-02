class CrawlJob < Struct.new(:site_id)
  def perform
    require 'open-uri'
    @site = Site.find site_id

    crawl_page @site.url
  end

  def crawl_page(url)
    doc = Nokogiri::HTML open(url)
    lorem_results = doc.search "[text()*='digitally']"
    if lorem_results
      lorem_results.each do |lr|
        @site.crawling_errors.create(error_type: 'Lorem ipsum', url: url, info: lr.to_html)
      end
    end
    puts self.class.name.humanize
  end
end
