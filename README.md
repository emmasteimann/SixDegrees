# Six Degrees of Separation
> or Six Degrees of Kevin Bacon

This app creates/reads an XML document of movies and actors, loading them into a graph datastore and allows you to anlayze the degree of distance between any two actors.

## Major Dependencies:

* Neo4j.rb - (runs an embedded neo4j graph database, so theres no need for an external server)
* JRuby - (needed for running Neo4j, as its all java)

## How to use

1. Go to http://localhost:3000
2. Type in a movie and click "load movie"
3. Repeat as desired
4. When ready to build xml, click "save xml" button
5. To compare actors, click "Compare" link
6. Select actors and click "Get Distance" to find degrees of separation
7. To reset, on home page, click "Reset All" button on bottom-right

## Notes:

* The version given, comes preloaded with a couple xml files (reset to start fresh!)
* TMDb is used for allowing users to pull in movie data
* There's a rake task to clear all data and xml files, run with -
> `bundle exec rake neo_db:clear_all`
* JRuby Activerecord sqlite3 is a dependency in the gemfile, but currently not used
* There's a few Neo/XML related specs, feel to run `rspec spec` or `guard`
* Paperclip is used with NeoXML model, its currently writing locally
* Neo4j-Paperclip requires an older Paperclip which doesn't play nice, so the initializer `paperclip.rb` monkey patches logger