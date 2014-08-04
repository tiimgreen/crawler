# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Speed up Nokogiri as mentioned here: http://rubyglasses.blogspot.co.uk/2009/07/40-speedup-using-nokogiri.html
config.gem "nokogiri"
ActiveSupport::XmlMini.backend='Nokogiri'

# Initialize the Rails application.
Rails.application.initialize!
