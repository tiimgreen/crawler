class CrawlsController < ApplicationController
  def new
    Delayed::Job.enqueue CrawlJob.new(params[:site_id])
    # If you want to run the crawl not in the background, uncomment
    # the following line:
    #CrawlJob.new(params[:site_id]).perform
    flash[:success] = 'Crawling site'
    redirect_to site_path params[:site_id]
  end
end
