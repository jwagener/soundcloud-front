# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
gem 'soundcloud-ruby-api-wrapper'
require 'soundcloud'
  
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


  consumer_token = ENV['SC_CONSUMER_TOKEN']
  consumer_secret = ENV['SC_CONSUMER_SECRET']
  $sc_consumer = Soundcloud.consumer(consumer_token, consumer_secret)
end
