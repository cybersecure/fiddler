require 'spec_helper'

describe Fiddler::Formatters::SearchRequestFormatter do
   it "should return a hash for the format" do
      Fiddler::Formatters::SearchRequestFormatter.format( { :owner => "jais.cheema" }).should be_a_kind_of(Hash)
   end

   it "should return a query key in hash with the search options" do
      search_hash = Fiddler::Formatters::SearchRequestFormatter.format( { :owner => "jais.cheema" })
      search_hash.keys.should include("query")
   end

   it "should return a format key in hash with the long option" do
      search_hash = Fiddler::Formatters::SearchRequestFormatter.format( { :owner => "jais.cheema" })
      search_hash.keys.should include(:format)
   end
end 