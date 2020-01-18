require 'metainspector'
require 'csv'

class Construct

  def initialize(date, site, url)
    @url = url
    @parsed = {site: site, url: @url, date_published: date}
  end

  def parse_and_construct
    fetch_metadata
    parse_metadata
    return @parsed
  end

  def construct_content
    metadata = fetch_metadata(row.last)
  end

  def fetch_metadata
    @page = MetaInspector.new(@url)
  end

  def parse_metadata
    @parsed[:title] = parsed_title
    @parsed[:raw_title] = @page.best_title
    @parsed[:description] = @page.description
    @parsed[:published_by] = @page.host
  end

  private

  def parsed_title
    @page.best_title.split('|').first.strip
  end
end

def start
  parsed_content = []
  CSV.foreach("../data/urls.csv") do |row|
    c = Construct.new(*row)
    parsed_content << c.parse_and_construct
    puts "Processed #{row.join(' - ')}"
  end

  write_to_csv(parsed_content)
end

def write_to_csv(content)
  CSV.open('../data/parsed_data.csv', 'wb') do |csv|
    csv << content.first.keys
    content.each do |row|
      csv << row.values
      puts "Added #{row[:url]} to csv"
    end
  end
end

start
