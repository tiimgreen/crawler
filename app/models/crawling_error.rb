class CrawlingError < ActiveRecord::Base
  belongs_to :site

  validates :error_type, presence: true
  validates :url,        presence: true
  validates :info,       presence: true
  validates :site_id,    presence: true
end
