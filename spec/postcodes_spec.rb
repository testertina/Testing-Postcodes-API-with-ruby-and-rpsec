require 'spec_helper'
require 'json'
require 'pry'

describe 'postcodes.rb' do

	# before(:each) will do something each time. (Slow with API)
	# before(:all) will do something once and apply it to each time. (Quicker with API, can be unsafe)
	
	before(:each) do
		@postcodesio = Postcodesio.new
	end

	def valid_json?(json)
		begin
			JSON.parse(json)
		rescue
			return false
		end
	end

	it 'check post code request response message is 200' do
		expect(@postcodesio.single_postcode_search('NW32EG')["status"]).to eql(200)
		
	end

	it 'check post code request response that postcode request matches postcode responded' do	
		expect(@postcodesio.single_postcode_search('NW32EG')["result"]["postcode"]).to eql("NW3 2EG")
	end

	# it 'post code request response is JSON format' do

	# 	expect(valid_json?(@postcodesio.single_postcode_search('NW32EG'))).to be true
	# end

	it 'check post code request to have an outward postcode of 2, 3, 4 characters and inwards of 3 characters and correct format' do
		expect(@postcodesio.single_postcode_search('NW32EG')["result"]["outcode"].length).to be_between(2, 4).inclusive
		expect(@postcodesio.single_postcode_search('NW32EG')["result"]["incode"].length).to eql(3)
		expect(@postcodesio.single_postcode_search('NW32EG')["result"]["postcode"]).to match(/^[a-zA-Z]{1,2}([0-9]{1,2}|[0-9][a-zA-Z])\s*[0-9][a-zA-Z]{2}$/)
	end

	it 'check if incorrect postcode entered in request returns a 404' do
		expect(@postcodesio.single_postcode_search('NDSA')["status"]).to eql(404)
		expect(@postcodesio.single_postcode_search('NDSA')["error"]).to eql("Postcode not found")
	end

	it "check if positional quality is between 1 and 9" do
		expect(@postcodesio.single_postcode_search('NW32EG')["result"]["quality"]).to be_between(1, 9).inclusive
	end

	it 'check country is one of the four constituent countries of the United Kingdom or the Channel Islands or the Isle of Man' do
		expect(@postcodesio.single_postcode_search('BT71NN')["result"]["country"]).to match(/|England|Wales|Scotland|Northern Ireland|/)
	end

	# it 'check if strategic health authority is one of the 10 specified SHA' do
	# 	expect(@postcodesio.single_postcode_search('BT71NN')["result"]["nhs_ha"]).to match(//)
	# end

	it 'check european_electoral_region is one of London, South East England, South West England, West Midlands, North West England, North East England, Yorkshire and the Humber, East Midlands, East of England, Northern Ireland, Scotland, Wales' do
		expect(@postcodesio.single_postcode_search('BT71NN')["result"]["european_electoral_region"]).to match(/|London|South East England|South West England|West Midlands|North West England|North East England|Yorkshire and the Humber|East Midlands|East of England|Northern Ireland|Scotland|Wales|/)
	end

	it 'check region is one of London, South East England, South West England, West Midlands, North West England, North East England, Yorkshire and the Humber, East Midlands, East of England, Northern Ireland, Scotland, Wales' do
		expect(@postcodesio.single_postcode_search('BT71NN')["result"]["region"]).to match(/|London|South East England|South West England|West Midlands|North West England|North East England|Yorkshire and the Humber|East Midlands|East of England|Northern Ireland|Scotland|Wales|/ or nil)
	end

	it 'check that multiple postcode search returns multiple postcodes' do

	end

end