class Site < ActiveRecord::Base
  before_save :format_link

  has_many :crawling_errors, dependent: :destroy

  validates :name, presence: true
  validates :url,  presence: true, format: URI::regexp(%w(http https))

  private

  def format_link
    self.url = url[0, url.length - 1] if self.url.split('').last == '/'
  end
end
