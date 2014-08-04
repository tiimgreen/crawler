class CrawlJob < Struct.new(:site_id)
  def perform
    require 'open-uri'
    @site = Site.find(site_id)
    @text_to_search = ["Lorem ipsum", "lorem ipsum", "Lorem Ipsum", "LOREM IPSUM"]
    @links = []

    @site.update_attributes(currently_crawling: true, last_crawled: Time.now)

    @site.crawling_errors.each { |e| e.destroy }

    # Crawl homepage
    crawl_page @site.url, @site.url
    gather_links_on_page @site.url, @site.url
    search_for_ga_code @site.url
    search_for_link_to_parallax @site.url

    @links.each_with_index do |arr, i|
      puts arr[0]
      crawl_page arr[0], arr[1], index: i
    end

    @site.update_attributes(currently_crawling: false)
  end

  def crawl_page(url, ref, options = {})
    begin
      search_for_lorem url, ref
      gather_links_on_page url, ref
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        he = @site.crawling_errors.build(error_type: '404', url: url, info: "Link found on page: #{ref}")
        he.new_record? ? he.save : he.destroy
      elsif e.message == '500 Internal Server Error'
        he = @site.crawling_errors.build(error_type: '500', url: url, info: "Internat server error, link on page: #{ref}")
        he.new_record? ? he.save : he.destroy
      end
    rescue
    end
  end

  def search_for_lorem(url, ref)
    begin
      @site.crawling_errors.create(error_type: 'Lorem ipsum', url: url, info: 'Lorem ipsum detected on this page.') if open(url).read.downcase.include?('lorem ipsum')
    rescue URI::InvalidURIError
    end
  end

  def gather_links_on_page(url, ref, options = {})
    doc = Nokogiri::HTML open(url)
    links = doc.css 'a'
    hrefs = links.map { |link| link.attribute('href').to_s }.uniq.sort.delete_if do |href|
      invalid_link_format href
    end

    hrefs.each do |link|
      formatted_link = link.include?('http://') || link.include?('https://') ? link : @site.url + link
      formatted_link = formatted_link.split('#')[0] if formatted_link.include?('#')
      arr = [formatted_link, url]
      @links.push arr unless nested_include(@links, arr)
    end
  end

  def search_for_ga_code(url)
    doc = open(url).read
    if (doc =~ /\b(UA)\b-[0-9]{6,8}-[0-9]{1}/).nil? && !doc.include?('google-analytics')
      ga = @site.crawling_errors.build(error_type: 'No Google Analytics Code', url: url, info: "No Google Analytics code was found on this page")
      ga.new_record? ? ga.save : ga.destroy
    end
  end

  def search_for_link_to_parallax(url)
    if (open(url).read =~ /href(=|-)("|')(https:\/\/|http:\/\/)?w{0,3}.?parall.ax(\/)?("|')/).nil?
      pl = @site.crawling_errors.build(error_type: 'No Parallax Link', url: url, info: "There is no link back to http://parall.ax")
      pl.new_record? ? pl.save : pl.destroy
    end
  end

  def search_for_utf_chars(url)
    if !(open(url).read =~ /((â€™)|(â€“)|(â„¢)|(º®)|(â€˜))/).nil?
      um = @site.crawling_errors.build(error_type: 'Invalid UTF characters found', url: url, info: 'Invalid UTF characters have been found on this page.')
      um.new_record? ? um.save : um.destroy
    end
  end

  def invalid_link_format(href)
    href.empty? || /^[#].*$/ =~ href || href == '/' ||
    (href[0] != '/' && !href.include?(@site.url.gsub('http://', ''))) ||
    (href[0] == '/' && href.include?('http')) ||
    href.include?('javascript:') || href.include?('mailto:') || href.include?('.zip') ||
    href.include?('.jpg') || href.include?('.png') || href.include?('twitter.com') ||
    href.include?('facebook.com') || href.include?('.exe') || href.include?('.bin')
  end

  def nested_include(nested_array, check)
    includes = false
    nested_array.each do |item|
      includes = true if item[0] == check[0]
    end
    includes
  end
end
