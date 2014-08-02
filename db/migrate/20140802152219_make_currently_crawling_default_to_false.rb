class MakeCurrentlyCrawlingDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :sites, :currently_crawling, :boolean, default: false
  end
end
