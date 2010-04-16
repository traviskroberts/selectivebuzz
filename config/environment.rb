# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # observer for restful authentication plugin
  config.active_record.observers = :user_observer

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'twitter'
  config.gem 'buzzr'

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'
end

# fix the way error fields are decorated in forms
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| "<span class=\"fieldWithErrors\">#{html_tag}</span>" }

TwitterCredentials = YAML.load(File.read(Rails.root + 'config' + 'twitter.yml'))