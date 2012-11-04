class Actor < Neo4j::Rails::Model
  property :name
  has_n(:acted_in).to(Movie).relationship(ActedIn)
end