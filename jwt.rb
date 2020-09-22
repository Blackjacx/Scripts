#!/usr/bin/env ruby

require "base64"
require "jwt"

key_file = ARGV[0]
key_id = "#{ARGV[1]}"
issuer_id = "#{ARGV[2]}"
private_key = OpenSSL::PKey.read(File.read("#{key_file}"))

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