class AddFinishedCrawlingAndLinksCrawledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :finished_crawling, :datetime
    add_column :sites, :links_crawled, :integer
  end
end
