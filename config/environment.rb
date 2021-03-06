# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

CONFIG_EXISTS = File.exist?("#{RAILS_ROOT}/config/config.yml")
DB_CONFIG_EXISTS = File.exist?("#{RAILS_ROOT}/config/database.yml")
HAS_MEMCACHE = `which memcached` != ""

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Load up bare minimum if we don't have a db set up yet
  unless DB_CONFIG_EXISTS
    config.frameworks -= [ :active_record ]
    config.plugins = []
  end

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  #config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  if HAS_MEMCACHE
    config.cache_store = :mem_cache_store, 'localhost', 'localhost:11211', { :namespace => "hydra" }
  else
    config.cache_store = :memory_store
  end

  config.gem "rubytorrent", :version => '0.3'
  config.gem "memcache-client", :version => '1.5.0', :lib => "memcache"
  config.action_controller.session = { :session_key => "_hydra_session_id", :secret => 'hydra project super s3333kr333t session secret' }
  
end

# Include your application configuration below
require 'core_class_extensions'
require 'rubytorrent'
require 'rubygems'
# gem 'memcache-client'

BASE_URL = "http://#{C[:domain_with_port]}/"
