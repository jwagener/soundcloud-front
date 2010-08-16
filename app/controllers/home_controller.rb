class HomeController < ApplicationController
  require 'open-uri'
  require 'uri'

  def index
    # if logged in render loggedin page
    if not session[:user_id].nil?
      @user = User.find(session[:user_id])
      
      @unfinished_jobs = UploadJob.find(:all, :conditions=> ['user_id = ?', @user.id], :order => "created_at desc", :limit => 5)
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
    
    flash[:notice] = nil
    access_token = OAuth::AccessToken.new($sc_consumer, @user.access_token, @user.access_token_secret)
    sc = Soundcloud.register({:access_token => access_token})
    
    if params[:remote_url]
      # check if url is a http or ftp url
      uri = URI.parse(params[:remote_url])
      if uri.scheme == nil or not (uri.scheme == 'http' or uri.scheme == 'ftp')
        raise Exception.new "Sorry, '#{params[:remote_url]}' this doesnt seem to be a http or ftp URL." 
      end

      Delayed::Job.enqueue UploadJob.create(:file_url => params[:remote_url], :user_id => @user.id, :state => "Pending", :params => params)
      
      flash[:notice] = "Your track is being uploaded!  Head over to <a target=\"_blank\" href=\"http://soundcloud.com/you\">SoundCloud</a>, and it'll be there soon."
    end    
    
    if params[:job] && params[:commit] == 'Cancel!'
      UploadJob.find(params[:job]).destroy
      flash[:notice] = "Your upload has been deleted.  So sad!"
    end
    
    if params[:job] && params[:commit] == 'Try Again!'
      
      u = UploadJob.find(params[:job])
      u.update_attributes(:state => 'Pending', :error_message => nil)
      Delayed::Job.enqueue u
      
      flash[:notice] = "We're trying your track again!  Head over to <a target=\"_blank\" href=\"http://soundcloud.com/you\">SoundCloud</a>, and it'll be there soon."
    end
    
    @unfinished_jobs = UploadJob.find(:all, :conditions=> ['user_id = ?', @user.id], :order => "created_at desc", :limit => 5)
    
  rescue Exception => exception
    RAILS_DEFAULT_LOGGER.error "EXCEPTION: '#{params[:remote_url]}' raised #{exception.message}"
    flash[:error] = "Oops, something went wrong: #{exception.message}."
  end  
end
