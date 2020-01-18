require 'csv'
require 'json'

def start
  final_content = {}
  CSV.foreach('../data/parsed_data.csv', headers: true) do |row|
    add_to_content(final_content, row)
  end

  write_to_file(final_content)
end

def add_to_content(hsh, data)
  site = data['site']
  hsh[site] ||= []

  hsh[site] << site_json(data)
end

def site_json(data)
  data.to_h.reject {|k, v| ['raw_title', 'site'].include? k}
end

def write_to_file(content)
  File.open('../data/content.json', 'w') do |f|
    f.write(JSON.pretty_generate(content))
  end
end

start
