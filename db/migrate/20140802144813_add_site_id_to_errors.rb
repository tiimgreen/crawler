class AddSiteIdToErrors < ActiveRecord::Migration
  def change
    add_column :errors, :site_id, :integer
  end
end
