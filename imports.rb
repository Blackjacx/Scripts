# Splits a string into components and returns them as an array.
# If the string is nil or empty or if the string just consists of delimiters it returns an empty array.
# Params:
# +string+:: The string to split.
# +delimiter+:: The delimiter which should be used to split.
def split_string(string, delimiter)
  if string.nil?
    return []
  end
  return string
    .split(',')
    .map{ |s| s.strip || s }
    .reject { |s| s.empty? }
end

# Uses a section from a changelog and converts them to an array of hashes of issue number and pr title.
# Params:
# +section+:: The section of a changelog representing a release. The format has to be like https://raw.githubusercontent.com/Blackjacx/SHSearchBar/develop/CHANGELOG.md.
def get_issue_numbers_and_titles(section)  
  issues_titles = []
  section.split(/\n/).each do |line|
    issue = line[/\* \[#(.*?)\]\(/m, 1]
    title = line[/\)\: (.*?) - \[@/m, 1]
    issues_titles.push( { "issue" => issue, "title" => title } ) if issue && !issue.empty? && title && !title.empty?
  end    
  return issues_titles
end