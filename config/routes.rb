SixDegrees::Application.routes.draw do


  match '/connections/compare' => 'connections#compare', :as => 'connection_compare'
  post '/connections/compare_data' => 'connections#compare_data', :as => 'connection_compare_data'
  post '/connections/save_xml' => 'connections#save_xml', :as => 'connection_save_xml'
  post '/connections/clear_xml_and_data' => 'connections#clear_xml_and_data', :as => 'connection_clear_xml_and_data'
  post '/connections/get_movies' => 'connections#get_movies', :as => 'connection_get_movies'
  root :to => 'connections#index'

end
