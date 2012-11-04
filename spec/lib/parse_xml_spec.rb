require 'spec_helper'

describe ParseXML do
  describe "will load xml/xsd files" do
    it "and will return a valid schema test" do
      p = ParseXML.new
      p.load_xml File.open(File.join(Rails.root, 'lib', 'assets', 'movies.xml'), 'r')
      p.load_xsd
      validation = p.is_valid_xml?
      validation.should be_true
    end
  end
end