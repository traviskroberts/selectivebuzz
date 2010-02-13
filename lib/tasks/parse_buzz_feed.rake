desc "Parses user buzz feeds and posts to twitter and facebook."
task(:parse_buzz_feed => :environment) do
  start = Time.now
  
  users = User.all
  last_run = start - (5*60)
  
  # go ahead and create a Facebooker session
  facebook_yaml = YAML::load(open("#{ENV['PWD']}/config/facebooker.yml"))
  facebook_api_key =  facebook_yaml['production']['api_key']
  facebook_secret_key =  facebook_yaml['production']['secret_key']
  facebook_session = Facebooker::Session.new(facebook_api_key, facebook_secret_key)
  
  users.each do |user|
    twitter = user.twitter_enabled
    facebook = user.facebook_enabled and !user.facebook_uid.blank?
    
    next if !twitter and !facebook
    
    feed_url = Buzzr::Feed.discover(user.google_username) rescue next
    buzz_feed = Buzzr::Feed.retrieve(feed_url)
    
    buzz_feed.entries.each do |entry|
      next
      updated = Time.parse(entry.updated.to_s)
      if updated > last_run
        message = entry.content.to_s
        
        # post to Twitter?
        if twitter and message.include?('#tweet')
          # remove the html tags and take out the #tweet hashtag (AND the #fb if it has it)
          tweet = message.gsub(/<\/?[a-z]+>/, '').gsub(/#tweet/, '').gsub(/#fb/, '').strip

          # tweet it up, focker
          user.client.update(tweet, {})
        end
        
        # post to Facebook?
        if facebook and message.include?('#fb')
          # remove the html tags and take out the #fb hashtag (AND the #tweet if it has it)
          facebook_status = message.gsub(/<\/?[a-z]+>/, '').gsub(/#fb/, '').gsub(/#tweet/, '').strip
          
          # get the facebook user so we can update the status
          facebook_user = Facebooker::User.new(user.facebook_uid, facebook_session)
          facebook_user.set_status(facebook_status)
        end
      end
    end
  end
  
  total_run = Time.now - start
  RAILS_DEFAULT_LOGGER.info "\nTotal run time for 'parse_buzz_feed' task: #{total_run} seconds.\n\n"
  RAILS_DEFAULT_LOGGER.flush
end