require 'rubygems'
#require 'yaml'
require 'bundler/setup'
Bundler.require

#require "#{File.dirname(__FILE__)}/lib"
Dir.glob('tasks/*.rake').each { |r| import r }

desc "Display Usage"
task :default do
  puts """
  usage:
    rake -T          # List all available tasks
    rake <command>  

"""

end
