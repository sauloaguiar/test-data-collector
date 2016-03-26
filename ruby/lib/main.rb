require_relative 'collector'
require "json"

class Main
    
    path = ARGV[0]
    sha1 = ARGV[1]
    collector = Collector.new(path, sha1)
    collector.collect!
    
    p "tests: "+collector.data["tests"].to_s
    p "success_rate: "+collector.data["success_rate"].to_s + "%"
end