require_relative 'collector'
require "json"

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
    p global_hash
end