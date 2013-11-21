namespace :db do
  desc "delete all records from all tables except schema_migrations"
  task :clear => :environment do
    app_name = Rails.application.class.parent_name
    puts "You're about to truncate database in #{Rails.env.upcase} environment"
    
    # print "Type application name to confirm (#{app_name}): "
    # STDOUT.flush
    # input = STDIN.gets.chomp
    # raise 'Exiting!' unless input == app_name
    
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    connection = ActiveRecord::Base.connection
    connection.tables.reject{|t| t == 'schema_migrations'}.each  do |t|
      connection.execute("DELETE FROM #{t}")
    end
  end
  desc "truncates all tables except schema_migrations"
  task :truncate => :clear
end