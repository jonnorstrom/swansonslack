require 'net/http'
require 'sinatra'
require 'json'
require 'uri'
require_relative 'quotes'

post '/swanson' do
  send_quote_to_slack(params[:response_url], get_quote)
end

def send_quote_to_slack(response_url, quote)
  uri = URI(response_url)
  req = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json'})

  req.body = format_body(quote)

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(req)
  end
end

def format_body(quote)
  {
    "response_type": "in_channel",
    "attachments": [
       {
         "fallback": "#{quote}",
         "text": "#{quote}",
         "mrkdwn_in": [
             "text",
         ]
       }
     ]
   }.to_json
end
