class DeleteErrors < ActiveRecord::Migration
  def change
    drop_table :errors
  end
end
