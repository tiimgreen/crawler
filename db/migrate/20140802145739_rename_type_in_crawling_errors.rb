class RenameTypeInCrawlingErrors < ActiveRecord::Migration
  def change
    rename_column :crawling_errors, :type, :error_type
  end
end
