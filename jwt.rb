#!/usr/bin/env ruby

require "base64"
require "jwt"

#
# JWT Debugger: https://jwt.io/
#

key_file_or_string = ARGV[0]
key_id = "#{ARGV[1]}"
issuer_id = "#{ARGV[2]}"

if File.exist?("#{key_file_or_string}")
  private_key = OpenSSL::PKey.read(File.read("#{key_file_or_string}"))
else
  private_key = OpenSSL::PKey.read("#{key_file_or_string}")
end

token = JWT.encode(
   {
    iss: issuer_id,
    iat: Time.now.to_i,
    exp: Time.now.to_i + 20 * 60,
    aud: "appstoreconnect-v1"
   },
   private_key,
   "ES256",
   header_fields={
     kid: key_id
   }
 )
puts token