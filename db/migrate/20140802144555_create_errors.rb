class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :type
      t.string :url
      t.text :additional_info

      t.timestamps
    end
  end
end
