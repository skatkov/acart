require "sequel"

DB = Sequel.connect(
  ENV['DATABASE_URL'] || "postgres:///acart_#{ENV.fetch('RACK_ENV', 'development')}?user=acart"
)


Link = DB[:links]
