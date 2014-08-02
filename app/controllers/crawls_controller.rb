class CrawlsController < ApplicationController
  def new
    #DelayedJob::enqueue CrawlJob.new(params[:site_id])
    CrawlJob.new(params[:site_id]).perform
    flash[:success] = 'Crawling site'
    redirect_to site_path params[:site_id]
  end
end
