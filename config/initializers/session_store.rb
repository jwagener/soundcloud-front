# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_SCUF_session',
  :secret      => '7b6e6b4a470c34b7a4c1932b3939018ec54850d2372cdf7db4fe515a3e3d1a475a949efb0c30b33ae4c75838160e70878bc3dca29083b7430410974e8d808779'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
