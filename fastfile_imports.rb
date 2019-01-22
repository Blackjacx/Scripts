# Splits a string into components and returns them as an array
def split_string(str)
  if str.nil?
    return []
  end
  return str.split(",").map{ |s| s.strip || s }.reject { |s| s.empty? }
end