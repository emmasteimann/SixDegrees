class NeoXML < Neo4j::Rails::Model
  require 'json'
  require 'net/http'
  require 'tempfile'
  include Neo4jrb::Paperclip
  property :name
  has_neo4jrb_attached_file :xml_file
  def self.clear_xml_files
     FileUtils.rm_rf(Rails.root.join('public','system'))
     Neo4j::Transaction.run { NeoXML.all.map(&:del) }
  end
  def build_xml_and_save(movies)
    movies = movies.split(",")
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.movies {
        movies.uniq.each{|film|
          film = CGI.unescapeHTML(film)
          response = Net::HTTP.get_response(URI.parse(URI.encode("http://private-bfa4-themoviedb.apiary.io/3/search/movie?api_key=10d50dac72f1591c5330d2e6a8275ff6&query=#{film}")))
          data = response.body
          result = JSON.parse(data)
          result = result["results"].first
          result_id = result["id"]
          result_title = result["title"]
          response = Net::HTTP.get_response(URI.parse(URI.encode("http://private-bfa4-themoviedb.apiary.io/3/movie/#{result_id}/casts?api_key=10d50dac72f1591c5330d2e6a8275ff6")))
          data = response.body
          result = JSON.parse(data)
          result_cast = []
          if result["cast"].any?
            result["cast"] = result["cast"].each_slice(5).first
            result["cast"].each{|item| result_cast << item["name"]}
          end
          result_struct = Struct.new(:title, :actors)
          movie_result = false
          if result["cast"]
            movie_result = result_struct.new(result_title, result_cast)
            xml.movie(:title => movie_result.title){
              movie_result.actors.map{ |actor|
                xml.actor(:name => actor)
              }
            }
          end
        }
      }
    end
    neo_xml = save_to_xml builder
    save_to_db neo_xml
  end

  private
  def save_to_db(neo_xml)
    p = ParseXML.new
    p.load_xml neo_xml

    if p.is_valid_xml?
      p.load_datastore
    end
  end
  def save_to_xml(builder)
    time_string = Time.now.strftime("%m/%d/%Y-%I:%M%p")
    temp_file = Tempfile.new(["tempfile", ".xml"])
    temp_file.write(builder.to_xml)
    neo_xml = Neo4j::Transaction.run { NeoXML.create(:name => time_string, :xml_file => temp_file)}
    return neo_xml.xml_file.to_file
  end

end