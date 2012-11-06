require 'spec_helper'

describe ParseXML do
  after(:each) do
    NeoService.clear_all
  end
  describe "will load xml/xsd files" do
    it "and will return a valid schema test" do
      p = ParseXML.new
      p.load_xml File.open(File.join(Rails.root, 'lib', 'assets', 'movies.xml'), 'r')
      validation = p.is_valid_xml?
      validation.should be_true
    end
  end
  describe "will load and save xml" do
    it "and will find actor - kevin bacon" do
      ParseXML.test
      kevin = Actor.find_by_name("Kevin Bacon")
      kevin.should_not be nil
    end
  end
  describe "will load and save xml" do
    it "and will find movie - the dark knight" do
      ParseXML.test
      dark_night = Movie.find_by_name("The Dark Knight")
      dark_night.should_not be nil
    end
  end
end