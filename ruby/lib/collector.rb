require "nokogiri"
require "json"

class Collector
   
   # Pass as argument the dirname that contains the /test-reports dir, scoverage.xml and date.txt files
   
   attr_reader :dirname
   attr_reader :data
   
   def initialize(dirname)
    @dirname = dirname
    start_global_data
   end
   
   def collect!
    get_test_reports
    get_coverage(@dirname + "/scoverage.xml")
    get_date(@dirname + "/date.txt")
    
    p get_data
   end
   
   def get_data
     filtered_data = {}
     filtered_data["tests"] = @data["tests"]
     filtered_data["success_rate"] = @data["success_rate"]
     filtered_data["coverage"] = @data["coverage"]
     filtered_data["date"] = @data["date"]
     return filtered_data
   end
   
   private
   
   def get_coverage(coverage_file)
    if (File.exists?(coverage_file)) 
      coverage_xml = File.open(coverage_file) { |f| Nokogiri::XML(f) }  
      root = coverage_xml.root
      save_coverage(root)
    else 
      save_coverage(nil)
    end
   end
  
   def get_date(date_file)
     save_date(date_file)
   end

   def get_test_reports
    Dir.glob(dirname+"/test-reports/*.xml") do |rb_file|
    # do work on files ending in .rb in the desired directory
        doc = File.open(rb_file) { |f| Nokogiri::XML(f) }
        root = doc.root
        save(root)
    end
   end
   
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
       if xml_node["tests"].to_i != 0
         file_data["tests"] = xml_node["tests"].to_i
       else
         file_data["tests"] = 1
       end
       file_data['errors'] = xml_node["errors"].to_i
       file_data['failures'] = xml_node["failures"].to_i
       file_data['success_rate'] = ((file_data["tests"] - (file_data['failures']+file_data['errors']))/file_data["tests"]) * 100
       
       #p "saved node: #{file_data}"
       update_global_data(file_data)
   end
   
   def save_coverage(xml_node)
      if (xml_node)
        @data["coverage"] = xml_node["statement-rate"]
      else
        @data["coverage"] = 0.0
      end
   end
   
   def save_date(date_file)
    if (File.exists?(date_file)) 
      File.open(date_file) { |f| @data["date"] = f.readline }
    else 
      @data["date"] = "null"
    end
   end
   
end
