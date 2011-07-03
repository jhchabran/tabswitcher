
require 'fileutils'

def coffee_is_available?
  ENV['PATH'].split(":").collect do |path| 
    File.exists? "#{path}/coffee"
  end.inject(false) do |result, present|
    result ||= present
  end
end

def if_coffee &block
  unless coffee_is_available?
    puts "CoffeeScript is missing, I couldn't find it in your $PATH"
    puts "Please install it before invoking me"
    exit(-1)
  else
    yield
  end
end

ROOT_PATH           = File.expand_path(File.dirname(__FILE__))
COFFEESCRIPTS_PATH  = ROOT_PATH + '/src'
JAVASCRIPTS_PATH    = ROOT_PATH + '/build'

namespace :coffee do
  desc "Build CoffeeScripts into site/javascripts"
  task :build do
    if_coffee do 
      system("coffee --output #{JAVASCRIPTS_PATH} --compile #{COFFEESCRIPTS_PATH}")
    end
  end

  desc "Watch for changes in Coffee files to refresh javascript" 
  task :watch do
    if_coffee do 
      system("coffee --output #{JAVASCRIPTS_PATH} --watch #{COFFEESCRIPTS_PATH}")
    end
  end
end
