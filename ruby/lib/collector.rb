require "nokogiri"
require "json"

class Collector
   
   attr_reader :dirname
   attr_reader :sha1
   attr_reader :data
   
   def initialize(dirname, sha1)
    @dirname = dirname
    @sha1 = sha1
    start_global_data
   end
   
   def collect!
    puts "Reading files from #{dirname}"       
    Dir.glob(dirname+"*.xml") do |rb_file|
    # do work on files ending in .rb in the desired directory
    
        doc = File.open(rb_file) { |f| Nokogiri::XML(f) }
        root = doc.root
        save(root)

    end
   end
   
   
   private
   
   def start_global_data
      @data = Hash.new
      @data["tests"] = 0
      @data["errors"] = 0
      @data["failures"] = 0
      @data["success_rate"] = 1
   end
   
   def update_global_data(file_data)
       @data[file_data['name']] = file_data
       
       @data["tests"] += file_data["tests"]
       @data["errors"] += file_data["errors"]
       @data["failures"] += file_data["failures"]
       @data["success_rate"] = ((@data["tests"] - (@data["failures"]+@data["errors"]))/@data["tests"]) * 100
   end
   
   def save(xml_node)
       file_data = Hash.new
       file_data['name'] = xml_node['name']
       file_data['tests'] = xml_node["tests"].to_i
       file_data['errors'] = xml_node["errors"].to_i
       file_data['failures'] = xml_node["failures"].to_i
       file_data['success_rate'] = ((file_data['tests'] - (file_data['failures']+file_data['errors']))/file_data['tests']) * 100
       
       #p "saved node: #{file_data}"
       update_global_data(file_data)
   end
   
end
