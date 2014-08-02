class CrawlJob < Struct.new(:site_id)
  def perform
    require 'open-uri'
    @site = Site.find site_id

    crawl_page site.url
  end

  def crawl_page(url)
    doc = Nokogiri::HTML open(url)
    lorem_results = doc.search "[text()*='digitally']"
    if lorem_results
      lorem_results.each do |lr|
        @site.errors.create(type: 'Lorem ipsum', url: url, additional_info: lr.inspect)
      end
    end
    puts self.class.name.humanize
  end
end
