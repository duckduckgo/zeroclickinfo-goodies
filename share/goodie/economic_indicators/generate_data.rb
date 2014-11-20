require 'json'
require 'csv'
require 'fileutils'

#extracts data from a world bank indicator file
def extract_data_from_world_bank_indicator(source_id,source,data_file)
  #world bank indicator data is a zip file .
  #we need to unzip it first 
  #assumes unzip is already installed on the system
  `unzip -o #{data_file} -d download`
  if !File.file? "download/#{source['target_file']}"
    puts "Could not find the target file in the zip"
    return
  end
  count = 0
  rows = CSV.read("download/#{source['target_file']}", encoding: "BOM|UTF-8:UTF-8", headers: false)
  #drop first two rows to get to the header
  rows = rows.drop(2)
  
  #figure out which columns have country names and data for our relevant year
  country_column = -1
  country_code_column = -1
  year_column = -1
  rows[0].each_with_index do |cell,index|
    if cell == "Country Name"
      country_column = index
    end
    if cell == "Country Code"
      country_code_column = index
    end
    if cell == source['relevant_year']
      year_column = index
    end 
  end
  if country_column < 0 or year_column < 0 or country_code_column < 0
    puts "CSV Data not as expected"
    return
  end
  #drop the header
  rows = rows.drop(1)
  #exclusion list of country codes, these are regions instead of countries
  exclude_country_codes = %w(ARB ANR CAA CEA CEB CEU CLA CME CSA CSS EAP EAS ECA ECS EMU FCS HIC HPC INX LAC LCN LCR LDC LIC LMC LMY MCA MEA MNA NOC OEC OED OSS PSS SCE SSA SSF SST UMC PSE MIC) 
  #iterate and create the hash
  data_hash = Hash.new
  rows.each do |row|
    country_code = row[country_code_column]
    if country_code.nil? or country_code.strip.length == 0 or exclude_country_codes.include?(country_code.strip)
      next
    end
    data_value = row[year_column] 
    if data_value.nil? or data_value.strip.length == 0
      next
    end

    #get country_name
    country_name = row[country_column]
    #clean it up
    country_name = country_name.gsub(/\((.*?)\)/,'') #remove content within ()
    country_name = country_name.split(',')[0] #remove content after,
    country_name = country_name.gsub(/[^a-z ]/i, ' ') #remove non alphabet chars
    country_name = country_name.gsub(' the',' ').gsub('sar',' ')
    country_name = country_name.gsub(/\s+/,' ')
    country_name = country_name.downcase
    data_hash[country_name] = row[year_column]
  end
  File.write("./#{source_id}.json",JSON.pretty_generate(data_hash)) 

end
#download_file
def download_file(url,destination_file)
  `wget #{url} -O #{destination_file}`
end

#fetches file using download_url 
def generate_data_file(source_id,source)
  download_file(source["download_url"],"download/#{source_id}.raw")
  if !File.file?("download/#{source_id}.raw")
    puts "Could Not Download Source file" 
    return
  end
  generated_hash = send("extract_data_from_#{source['source_type'].downcase}",source_id,source,"download/#{source_id}.raw")
   
end
#remove download folder if it exists and create a new
#load data_sources
FileUtils.rm_rf('download')
Dir.mkdir 'download'
sources = JSON.parse(File.read('./data_sources.json'))
sources.each do |source_id,source|
  generate_data_file(source_id,source)
end
FileUtils.rm_rf('download')
