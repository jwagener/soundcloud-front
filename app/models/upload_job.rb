require 'open-uri'
require 'uri'
require 'pathname'
gem 'soundcloud-ruby-api-wrapper'
require 'soundcloud'

class UploadJob < ActiveRecord::Base
  belongs_to :user
  serialize :params
  
  module OverwritePath
    def path
      path = self.base_uri.path
      Pathname.new(path).basename.to_s
    end
  end
  
  def sc
    access_token = OAuth::AccessToken.new($sc_consumer, user.access_token, user.access_token_secret)
    sc = Soundcloud.register({:access_token => access_token})
  end
  
  def perform
    logger.warn("upload job started #{id}")

    # use open from 'open-uri' gem to download the file
    update_attributes!(:state => 'Downloading')
    temp_file = open file_url
    temp_file.extend OverwritePath
    
    update_attributes!(:state => 'Uploading')
    
    track = sc.Track.new    
    track.title       = params[:title]
    track.sharing     = "private"
    track.tag_list    = "SoundCloudFront"
    track.asset_data  = temp_file
    track.save
    
    update_attributes!(:state => 'Finished', :error_message => nil)
    logger.warn("upload job finished #{id}")
  end
end