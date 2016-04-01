require_relative 'collector'
require "json"
require 'date'

class Main
    
    # Pass the data dir as argument
    
    Dir.chdir(ARGV[0])
    
    # store the data relative to each sha1 folder
    global_hash = {}
    
    # for every folder
    Dir.glob("*") do |data|
        # use the collector to get data from the xml's 
        collector = Collector.new(File.join(Dir.pwd + "/" + data))
        collector.collect!
        global_hash[data] = collector.get_data
        
    end
    new_hash = global_hash.sort_by { |key, value| DateTime.parse(value["date"], '%Y-%m-%d %H:%M:%S %z') }.to_h

    p new_hash
    
end