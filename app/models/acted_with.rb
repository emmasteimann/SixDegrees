class ActedWith < Neo4j::Rails::Relationship
  property :on_movie, :index => :exact
end