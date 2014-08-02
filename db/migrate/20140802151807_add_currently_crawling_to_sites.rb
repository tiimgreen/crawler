class AddCurrentlyCrawlingToSites < ActiveRecord::Migration
  def change
    add_column :sites, :currently_crawling, :boolean
    add_column :sites, :progress, :float
  end
end
