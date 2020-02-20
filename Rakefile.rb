require "rake/testtask"

Rake::TestTask.new("test") do |t|
  t.pattern = "test/**/*_test.rb"
end

task default: :test


# Migrate

migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  require_relative 'db'
  require 'logger'
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
end

desc "Migrate test database to latest version"
task :test_up do
  migrate.call('test', nil)
end

desc "Migrate test database all the way down"
task :test_down do
  migrate.call('test', 0)
end

desc "Migrate test database all the way down and then back up"
task :test_bounce do
  migrate.call('test', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end

desc "Migrate development database to all the way down"
task :dev_down do
  migrate.call('development', 0)
end

desc "Migrate development database all the way down and then back up"
task :dev_bounce do
  migrate.call('development', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate production database to latest version"
task :prod_up do
  migrate.call('production', nil)
end

# Utils

desc "setup .env files"
task :setup do |t, args|
  lower_name = "acart"

  File.write('.env.rb', <<END)
case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['DATABASE_URL'] ||= "postgres:///#{lower_name}_test?user=#{lower_name}"
when 'production'
  ENV['DATABASE_URL'] ||= "postgres:///#{lower_name}_production?user=#{lower_name}"
else
  ENV['DATABASE_URL'] ||= "postgres:///#{lower_name}_development?user=#{lower_name}"
end
END
end

