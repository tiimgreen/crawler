class AddLastCrawledToSites < ActiveRecord::Migration
  def change
    add_column :sites, :last_crawled, :datetime
  end
end
