require_relative 'collector'
require "json"

class Main
    
    path = ARGV[0]
    sha1 = ARGV[1]
    collector = Collector.new(path, sha1)
    collector.collect!
    
    p collector.data.to_json
end