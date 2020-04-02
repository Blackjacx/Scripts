require 'octokit'

# Gets all swift packages and lists them in a nice markdown file.
# Find docs
#   - https://developer.github.com/v3/guides/traversing-with-pagination/#consuming-the-information
#   - https://help.github.com/en/github/searching-for-information-on-github/searching-code#search-by-filename
#   - https://octokit.github.io/rest.js/v17#search-repos

client = Octokit::Client.new :access_token => ENV['GITHUB_TOKEN']

results = client.search_code('filename:Package.swift', :per_page => 100)
total_count = results.total_count

last_response = client.last_response
number_of_pages = last_response.rels[:last].href.match(/page=(\d+).*$/)[1]

puts last_response.rels[:last].href
puts "There are #{total_count} results, on #{number_of_pages} pages!"


# while [ 1 ]
# do 
#   header=$(curl -s -I "$url" -H "Authorization: token $GITHUB_TOKEN")
#   last_page=$(echo  $header | grep '^Link:' | sed -e 's/^Link:.*<//g' -e 's/>.*$//g')
#   echo $last_page
#   echo $header
#   # curl -I "https://api.github.com/search/code?q=filename:Package.swift&per_page=60000" -H "Authorization: token $GITHUB_TOKEN" | jq '.items[].repository.name'
#   # curl -s "https://api.github.com/search/code?q=filename:Package.swift" -H "Authorization: token $GITHUB_TOKEN" | jq '.items[].repository | {description,full_name,name,html_url}'
#   break
# done