class ParseXML
  attr_accessor :xml_file, :xsd_file
  def initialize
    return load_xsd
  end
  def self.test
    p = self.new
    p.load_xml File.open(File.join(Rails.root, 'lib', 'assets', 'movies.xml'), 'r')
    p.load_datastore
  end
  def load_xml(file)
    if file.is_a? File
      @xml_file = file
      return parse_in_nokogiri
    else
      return false
    end
  end
  def load_xsd
    return @xsd_file = File.open(File.join(Rails.root, 'lib', 'assets', 'movies.xsd'), 'r')
  end
  def parse_in_nokogiri
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
    end
  end
  def is_valid_xml?
    if @xml_file and @xsd_file
      return @noko_xsd.valid?(@noko_xml)
    else
      return false
    end
  end
  def print_xml_listing
    unless @noko_xml.nil? and @noko_xsd.nil?
      @noko_xml.xpath('//movie').map{ |movie|
        puts movie.attr("title")
        movie.xpath("actor").map{ |actor|
          puts "    " + actor.attr("name")
        }
      }
    end
  end
  def load_datastore
    unless @noko_xml.nil? and @noko_xsd.nil?
      @noko_xml.xpath('//movie').map{ |movie|
        movie_neo = Neo4j::Transaction.run { Movie.find_or_create_by(:name => movie.attr("title")) }
        movie.xpath("actor").map{ |actor|
          actor_neo = Neo4j::Transaction.run { Actor.find_or_create_by(:name => actor.attr("name")) }
          movie_neo.actors << actor_neo
        }
        movie_neo.actors.map{ |actor|
          other_actors_in_movie = movie_neo.actors.to_a.dup
          other_actors_in_movie.delete(actor)
          other_actors_in_movie.map{ |associate|
            Neo4j::Transaction.run { Neo4j::Relationship.new(:acted_with, actor, associate)[:on_movie] = movie_neo.name }
          }
        }
        Neo4j::Transaction.run { movie_neo.save! }
      }
    end
  end
end