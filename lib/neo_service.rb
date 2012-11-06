class NeoService

  class << self
    # Get the distance apart
    def get_edges(from_node, to_node)
      if (from_node.to_i == 0) and (to_node.to_i == 0)
        from_node = Actor.find_by_name(from_node)
        to_node = Actor.find_by_name(to_node)
      else
        from_node = Actor.find(from_node)
        to_node = Actor.find(to_node)
      end
      path_between = Neo4j::Algo.shortest_path(from_node,to_node).outgoing(:acted_with)
      relation_string = ""
      connection_string = ""
      total_connections = 0
      if path_between.count != 0
        relationship_path = path_between.dup
        relationship_count = relationship_path.rels.count
        total_connections = (relationship_count - 1)
        if relationship_count == 1
          relation_string = "Acted in same movie"
        else
          relation_string =  "Separated by " + (relationship_count-1).to_s + " movie connections"
        end
        idx = 0

        path_between.each{|item|
          if item.class == Neo4j::Node
            if idx < relationship_count
              grammar = ""
              grammar += " who" if idx > 0
              connection_string += item[:name] + grammar + " acted in "
            else
              connection_string += item[:name]
            end
          elsif item.class == Neo4j::Relationship
            connection_string += item[:on_movie] + " with "
            idx = idx + 1
          end
        }
      else
        relation_string = from_node.name + " is not connected to " + to_node.name
      end
      return {connection_string: connection_string, relation_string: relation_string, total_connections: total_connections}
    end

    # Runs a cypher query to clear out relationships and nodes
    def clear_all
      Neo4j::Transaction.run { Neo4j._query("START n=node(*) MATCH n-[r?]-() WHERE ID(n) <> 0 DELETE n,r;") }
    end
  end
end