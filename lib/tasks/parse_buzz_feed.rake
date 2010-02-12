desc "Parses user buzz feeds and posts to twitter and facebook."
task(:parse_buzz_feed => :environment) do
  users = User.all
  last_run = Time.now - (5*60)
  
  users.each do |user|
    twitter = user.twitter_enabled
    facebook = false
    
    next if !twitter and !facebook
    
    feed_url = Buzzr::Feed.discover(user.google_username) rescue next
    buzz_feed = Buzzr::Feed.retrieve(feed_url)
    
    buzz_feed.entries.each do |entry|
      updated = Time.parse(entry.updated.to_s)
      if updated > last_run
        message = entry.content.to_s
        if twitter and message.include?('#tweet')
          # remove the html tags and take out the #tweet hashtag
          tweet = message.gsub(/<\/?[a-z]+>/, '').gsub(/#tweet/, '')

          # tweet it up, focker
          user.client.update(tweet, {})
        end
      end
    end
  end
  
end