Neo4j::Config[:logger] = Logger.new(STDOUT)
# neo4j-paperclip uses older version of paperclip
# where logger is still bound to active record
module Paperclip
  class << self
    def logger
      if Neo4j::Config[:logger]
        Neo4j::Config[:logger]
      else
        Rails.logger
      end
    end
  end
end