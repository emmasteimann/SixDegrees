class Actor < Neo4j::Rails::Model
  property :name, :index => :exact, :unique => true
  has_n(:acted_in).to(Movie).relationship(ActedIn)
  has_n(:acted_with).relationship(ActedWith)

  def acted_in_movies
    films = []
    self.acted_in_rels.map{|film|
      films << film.end_node.name
    }
    return films
  end
end