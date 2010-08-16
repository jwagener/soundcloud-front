# Re-definitions are appended to existing tasks
task :environment
task :merb_env

namespace :jobs do
  desc "Clear the delayed_job queue."
  task :clear => [:merb_env, :environment] do
    Delayed::Job.delete_all
  end

  desc "Start a delayed_job worker."
  task :work => [:merb_env, :environment] do
    
    $sc_host = 'soundcloud.com'
    consumer_token = ENV['SC_CONSUMER_TOKEN']
    consumer_secret = ENV['SC_CONSUMER_SECRET']
    $sc_consumer = Soundcloud.consumer(consumer_token, consumer_secret, "http://api.#{$sc_host}")
    
    Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
  end
end
