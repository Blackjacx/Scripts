#!/usr/bin/ruby

require 'net/http'
require 'faraday'
require 'faraday_middleware'

def usage(message:)
  puts message
  puts "Usage: export ASC_AUTH_HEADER=\"$(asc_auth_header)\" && #{$0} [tester_group_name]"
  puts "If tester group is not specified, all groups are returned, also `App Store Connect Users`"
  puts "Quit..."
end

group = ARGV[0]

conn = Faraday.new 'https://api.appstoreconnect.apple.com/v1' do |c|
  c.response :json, :content_type => /\bjson$/
end

conn.headers = {'Content-Type' => 'application/json', 'Authorization' => ENV["ASC_AUTH_HEADER"]}

all_groups = conn
  .get('betaGroups')
  .body['data']

if group.nil?
  filtered_groups = all_groups
else
  filtered_groups = all_groups.select { |array| array['attributes']['name'] == "#{group}" }
end

puts filtered_groups
  .map { |group| group['id'] }
  .join(' ')