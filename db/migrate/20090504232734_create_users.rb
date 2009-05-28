class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :sc_user_id
      t.string :sc_username
      t.string :access_token
      t.string :access_token_secret
      t.string :upload_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
