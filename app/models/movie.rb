class Movie < Neo4j::Rails::Model
  property :name, :index => :exact, :unique => true
  has_n(:actors).from(Actor, :acted_in)

  def actors_in_movie
    actors = []
    self.actors_rels.map{|actor|
      actors << actor.start_node.name
    }
    return actors
  end
end