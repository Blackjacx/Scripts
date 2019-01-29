require "base64"
require "jwt"
ISSUER_ID = "P4LECE5B35"
KEY_ID = "NCWZ5SAFTZ"
key_file = ARGV[0]
private_key = OpenSSL::PKey.read(File.read("#{key_file}"))

token = JWT.encode(
   {
    iss: ISSUER_ID,
    iat: Time.now.to_i,
   },
   private_key,
   "ES256",
   header_fields={
     kid: KEY_ID }
 )
puts token