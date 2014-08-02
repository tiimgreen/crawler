class CreateCrawls < ActiveRecord::Migration
  def change
    create_table :crawls do |t|
      t.integer :site_id

      t.timestamps
    end
  end
end
