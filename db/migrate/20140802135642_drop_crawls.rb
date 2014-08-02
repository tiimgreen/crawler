class DropCrawls < ActiveRecord::Migration
  def change
    drop_table :crawls
  end
end
