class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :email,                     :limit => 100
      t.string    :name,                      :limit => 100, :default => '', :null => true
      t.string    :crypted_password,          :limit => 40
      t.string    :salt,                      :limit => 40
      t.string    :remember_token,            :limit => 40
      t.datetime  :remember_token_expires_at  
      t.string    :activation_code,           :limit => 40
      t.datetime  :activated_at
      t.string    :google_username,           :limit => 40
      t.boolean   :twitter_enabled,           :default => false
      t.string    :twitter_name,              :limit => 40
      t.string    :twitter_token
      t.string    :twitter_secret
      
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
