class User < ActiveRecord::Base
  has_many :upload_jobs
end
