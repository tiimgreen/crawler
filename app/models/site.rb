class Site < ActiveRecord::Base
  has_many :crawling_errors, dependent: :destroy
end
