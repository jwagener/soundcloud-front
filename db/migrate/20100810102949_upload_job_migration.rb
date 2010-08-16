class UploadJobMigration < ActiveRecord::Migration
  def self.up
    create_table :upload_jobs do |t|
      t.integer  :user_id
      t.string   :file_url
      t.text     :params
      t.string   :state
      t.string   :error_message
      

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_jobs
  end
end
