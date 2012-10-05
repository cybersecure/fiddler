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

   it "should return proper query for request" do
      Fiddler::Formatters::SearchRequestFormatter.format( { :owner => "jais.cheema" })["query"].should eql("Owner LIKE 'jais.cheema'")
   end

   it "should return proper query for array values for a condition" do
      Fiddler::Formatters::SearchRequestFormatter.format( { :status => [:open, :resolved] })["query"].should eql("( Status = 'open' OR Status = 'resolved' )")
   end

   it "should return proper query for mixed conditions" do
      search_hash = Fiddler::Formatters::SearchRequestFormatter.format( :owner => "jais.cheema", :status => [:open, :resolved], :queue => "Advanced Support")
      search_hash["query"].should eql("Queue = 'Advanced Support' AND ( Status = 'open' OR Status = 'resolved' ) AND Owner LIKE 'jais.cheema'")
   end
end 