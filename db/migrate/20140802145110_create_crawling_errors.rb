class CreateCrawlingErrors < ActiveRecord::Migration
  def change
    create_table :crawling_errors do |t|
      t.string :type
      t.string :url
      t.text :info
      t.integer :site_id

      t.timestamps
    end
  end
end
