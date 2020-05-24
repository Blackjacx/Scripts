#!/usr/bin/ruby

require 'net/http'
require 'faraday'
require 'faraday_middleware'

def usage(message:)
  puts message
  puts "Usage: export ASC_AUTH_HEADER=\"$(asc_auth_header)\" && #{$0} <tester_group_name>"
  puts "Quit..."
end

group = ARGV[0]

if group.nil?
  usage(message: "Tester group name missing!")
  exit(1) 
end

conn = Faraday.new 'https://api.appstoreconnect.apple.com/v1' do |c|
  c.response :json, :content_type => /\bjson$/
end

conn.headers = {'Content-Type' => 'application/json', 'Authorization' => ENV["ASC_AUTH_HEADER"]}

puts conn
  .get('betaGroups')
  .body['data']
  .select { |array| array['attributes']['name'] == "#{group}" }
  .map { |group| group['id'] }
  .join(' ')