class HomeController < ApplicationController

  require 'open-uri'
#  require 'cgi'
#  require 'net/http'
  require 'uri'

  def index
    # if logged in render loggedin page
    if not session[:user_id].nil?
      @user = User.find(session[:user_id])
      render :action => :loggedin
    end
  end
  
  def loggedin
    # if not logged in redirect/render home/index page
    if not session[:user_id].nil?
      @user = User.find(session[:user_id])
    else
      render :action => :index
    end
        
    access_token = OAuth::AccessToken.new($sc_consumer, @user.access_token, @user.access_token_secret)
    sc = Soundcloud.register({:access_token => access_token})
    
    if params[:remote_url]
      
      # check if url is a http or ftp url
      uri = URI.parse(params[:remote_url])
      if uri.scheme == nil or not (uri.scheme == 'http' or uri.scheme == 'ftp')
        raise Exception.new "Sorry, '#{params[:remote_url]}' this doesnt seem to be a http or ftp URL." 
      end

      # In a realworld application, we would run the next lines in a background process
      # but to keep it simple we do up- and downloading right here

      # use open from 'open-uri' gem to download the file
      file = open uri
      
      # create a new track and upload it to Soundcloud
      track = sc.Track.new
      track.title = params[:title]
      track.sharing = "private"
      track.asset_data = file
      track.save
            
      flash[:notice] = "Your track was uploaded! You can find it <a target=\"_blank\" href=\"#{track.permalink_url}\">here</a>."
    end     
    
  rescue Exception => exception
    RAILS_DEFAULT_LOGGER.error "EXCEPTION: '#{params[:remote_url]}' raised #{exception.message}"
    flash[:error] = "Oops, something went wrong: #{exception.message}."
  end  
end
