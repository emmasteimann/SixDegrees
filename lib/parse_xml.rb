class ParseXML
  attr_accessor :xml_file, :xsd_file
  def load_xml(file)
    if file.is_a? File
      return @xml_file = file
    else
      return false
    end
  end
  def load_xsd
    @xsd_file = File.open(File.join(Rails.root, 'lib', 'assets', 'movies.xsd'), 'r')
  end
  def is_valid_xml?
    unless @xml_file.nil? and @xsd_file.nil?
      begin
        @noko_xml = Nokogiri::XML(@xml_file) { |config| config.strict }
      rescue Nokogiri::XML::SyntaxError => e
        puts "caught exception: #{e}"
        return false
      end
      begin
        @noko_xsd = Nokogiri::XML::Schema(@xsd_file) { |config| config.strict }
      rescue Nokogiri::XML::SyntaxError => e
        puts "caught exception: #{e}"
        return false
      end
      @noko_xsd.valid?(@noko_xml)
    end
  end
  def load_to_datastore
    @noko_xml.xpath('//movie').map{ |movie|
      puts movie.attr("title")
      movie.xpath("actor").map{ |actor|
        puts "    " + actor.attr("name")
      }
    }
  end
end