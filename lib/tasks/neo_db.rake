require "neo4j"

namespace :neo_db do
  task :clear_all => :environment do
    NeoService.clear_all
    NeoXML.clear_xml_files
  end
end