class CrawlJob < Struct.new(:site_id)
  def perform
    require 'open-uri'
    @site = Site.find(site_id)
    @text_to_search = ["Lorem ipsum", "lorem ipsum", "Lorem Ipsum", "LOREM IPSUM"]
    @links = []

    @site.update_attributes(currently_crawling: true, last_crawled: Time.now)

    @site.crawling_errors.each { |e| e.destroy }

    crawl_page @site.url
    @site.update_attributes(currently_crawling: false)
  end

  def crawl_page(url, options = {})
    search_for_lorem url
    gather_links_on_page url
  end

  def search_for_lorem(url)
    doc = Nokogiri::HTML open(url)
    lorem_results = []

    for string in @text_to_search
      results = doc.search("[text()*='#{string}']")
      lorem_results.push(results) if results.present?
    end

    if lorem_results.any?
      lorem_results.each do |lr|
        @site.crawling_errors.create(error_type: 'Lorem ipsum', url: url, info: lr.to_html)
      end
    end
  end

  def gather_links_on_page(url)
    doc = Nokogiri::HTML open(url)
    links = doc.css 'a'
    hrefs = links.map { |link| link.attribute('href').to_s }.uniq.sort.delete_if do |href|
      invalid_link_format href
    end
  end

  def invalid_link_format(href)
    href.empty? || /^[#].*$/ =~ href || href == '/' ||
    (href[0] != '/' && !href.include?(@site.url.gsub('http://', ''))) ||
    (href[0] == '/' && href.include?('http')) ||
    href.include?('javascript:') || href.include?('mailto:') || href.include?('.zip') ||
    href.include?('.jpg') || href.include?('.png')
  end

end
