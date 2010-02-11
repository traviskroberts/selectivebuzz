desc "Parses user buzz feeds and posts to twitter and facebook."
task(:parse_buzz_feed => :environment) do
  require 'rss'
  require 'twitter'
  
  users = User.all
  last_run = Time.now - (5*60)
  
  users.each do |user|
    twitter = user.twitter_enabled
    facebook = false
    
    next if !twitter and !facebook
    
    buzz_feed = RSS::Parser.parse(open("http://buzz.googleapis.com/feeds/crappola/public/posted").read, false) rescue next

    buzz_feed.entries.each do |entry|
      updated = Time.parse(entry.updated.to_s)
      if updated > last_run
        message = entry.content.to_s
        if twitter and message.include?('#tweet')
          # remove the content tags and take out the #tweet hashtag
          tweet = message.gsub(/\<[a-z1-9 =\"]+\>/, '').gsub(/\<\/[a-z]+\>/, '').gsub(/&lt;[\/a-z]+&gt;/, '').gsub(/#tweet/, '')

          # tweet it up, focker
          user.client.update(tweet, {})
        end
      end
    end
  end
  
end