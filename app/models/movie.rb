class Movie < Neo4j::Rails::Model
  property :name
  has_n(:actors).from(Actor, :acted_in)
end