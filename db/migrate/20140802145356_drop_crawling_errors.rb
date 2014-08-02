class DropCrawlingErrors < ActiveRecord::Migration
  def change
    drop_table :crawling_errors
  end
end
