require 'spec_helper'

#typoeus 0.4.2 test
describe Typhoeus::Request do
  let(:options) { {} }
  let(:request) { Typhoeus::Request.new(url, options) }
  
  before do
    @dataset = 
    [
      #basics
      ["http://a.com", {:foo => '1'}, "http://a.com?foo=1"],
      ["http://a.com", {:foo => 1}, "http://a.com?foo=1"],
      ["http://a.com", {:foo => nil}, "http://a.com?foo="],  
      # alphabatizing
      ["http://a.com", {:foo => '1', :bar => '2', :xyz => '3'}, "http://a.com?bar=2&foo=1&xyz=3"], 
      ["http://a.com", {:foo => nil, :bar => '2', :xyz => '3'}, "http://a.com?bar=2&foo=&xyz=3"], 
      # encoding
      ["http://a.com", {:foo => '!"hello"%'}, "http://a.com?foo=%21%22hello%22%25"],
      ["http://a.com", {:foo => '!"hello"%', :bar => 2}, "http://a.com?bar=2&foo=%21%22hello%22%25"],
      # combining url params with :params
      # apparently 0.4.2 didn't do this .. whoops :)
      ["http://a.com?a=a&b=3&y=2", {:foo => '1'}, "http://a.com?a=a&b=3&foo=1&y=2"],  
      ["http://a.com?a=a&b=3", {:foo => '!"hello"%'}, "http://a.com?a=a&b=3&foo=%21%22hello%22%25"]
    ]
  end
  
  it "should assert the correct url" do
    @dataset.each do |set|
      (url,params,expected) = set
      Typhoeus::Request.new(url, :params => params).url.should eq expected
    end
  end
end