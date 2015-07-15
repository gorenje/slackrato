if File.exists?(".env")
  require 'dotenv'
  Dotenv.load
end

task :environment do
  require_relative 'app.rb'
end

Dir[File.join(File.dirname(__FILE__), 'lib', 'tasks','*.rake')].
  each { |f| load f }
