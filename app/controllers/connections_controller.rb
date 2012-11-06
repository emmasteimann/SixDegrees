class ConnectionsController < ApplicationController
  require 'json'
  require 'net/http'
  def index

  end

  def compare

  end

  def compare_data
    @compare_hash = NeoService.get_edges(params[:actor_one], params[:actor_two])
  end


  def clear_xml_and_data
    NeoXML.clear_xml_files
    NeoService.clear_all
  end

  def save_xml
    if params[:movie][:names].blank?
      redirect_to :back
      return
    end
    neo_xml = NeoXML.new
    neo_xml.build_xml_and_save(params[:movie][:names])
    redirect_to :action => :index
  end

  def get_movies
    response = Net::HTTP.get_response(URI.parse(URI.encode("http://private-bfa4-themoviedb.apiary.io/3/search/movie?api_key=10d50dac72f1591c5330d2e6a8275ff6&query=#{params[:movie][:name]}")))
    data = response.body
    result = JSON.parse(data)
    result = result["results"].first
    result_id = result["id"]
    result_title = CGI.unescapeHTML(result["title"])
    response = Net::HTTP.get_response(URI.parse(URI.encode("http://private-bfa4-themoviedb.apiary.io/3/movie/#{result_id}/casts?api_key=10d50dac72f1591c5330d2e6a8275ff6")))
    data = response.body
    result = JSON.parse(data)
    result_cast = []
    if result["cast"].any?
      result["cast"] = result["cast"].each_slice(5).first
      result["cast"].each{|item| result_cast << CGI.unescapeHTML(item["name"])}
    end
    result_struct = Struct.new(:title, :actors)
    @result = false
    if result["cast"]
      @result = result_struct.new(result_title, result_cast)
    end
  end
end
