require 'net/http'

class ShopsController < ApplicationController

	def index
		url = "https://api.gnavi.co.jp/RestSearchAPI/v3/";
		prms = URI.encode_www_form(
			{
			    keyid: "6463bc55622ce5ad6df3afe4bd4d9815",
			    address: params[:search]
			}
		)
		parsed_url = URI.parse(url + "?" + prms)
		@query = parsed_url.query
		http = Net::HTTP.new(parsed_url.host, parsed_url.port)
		http.use_ssl = (parsed_url.scheme == 'https')
		response = http.get(parsed_url.request_uri)
		@result = JSON.parse(response.body)
	end
end
