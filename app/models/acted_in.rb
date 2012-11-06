class ActedIn < Neo4j::Rails::Relationship
  property :has_acted_in, :index => :exact
end