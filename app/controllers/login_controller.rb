class LoginController < ApplicationController

  require 'oauth'
  require 'json'
  
  # this will get a oauth request token from Soundcloud and 
  # will redirect the user to the Soundcloud authorize page
  # it stores request token and secret in the session to remember it, when he returns to the callback page
  
  # Insert your consumer key and secret here:  
  $sc_consumer = Soundcloud.consumer('YOUR_CONSUMER_KEY','YOUR_CONSUMER_SECRET')
  
  def redirect
    callback_url = url_for :action => :callback
    sc_request_token = $sc_consumer.get_request_token(:oauth_callback => callback_url)
    session[:sc_request_token] = sc_request_token.token
    session[:sc_request_token_secret] = sc_request_token.secret
    @authorize_url = "http://soundcloud.com/oauth/authorize?oauth_token=#{sc_request_token.token}"

    redirect_to @authorize_url
  end

  # after authentication at the Soundcloud authorize page, the user will land here
  # we get the access_token and use it to get the Soundcloud user resource 
  # then we look in our db to see if we know this user already otherwise we add him.
  # he will then be redirected to the loggedin page.
  def callback
    sc_request_token = OAuth::RequestToken.new($sc_consumer, session[:sc_request_token], session[:sc_request_token_secret])
    sc_access_token = sc_request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])  
    sc = Soundcloud.register({:access_token => sc_access_token})
    me = sc.User.find_me

    # check if user with me.id exists, update username & oauth stuff otherwise create a new user
    user = User.find_by_sc_user_id(me.id)
    if user.nil?
      user = User.create({:sc_user_id => me.id, :sc_username => me.username,
               :access_token => sc_access_token.token, :access_token_secret => sc_access_token.secret })
    else
      user.sc_username = me.username
      user.access_token = sc_access_token.token
      user.access_token_secret = sc_access_token.secret
      user.save!
    end
    
    session[:user_id] = user.id
    redirect_to :controller => :home
  end
  
  # delete his session and redirect to home
  def logout
    session[:user_id] = nil
    flash[:notice] = "You've logged out. Good bye!"    
    redirect_to :controller => :home      
  end
end
