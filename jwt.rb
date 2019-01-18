require "base64"
require "jwt"
ISSUER_ID = "P4LECE5B35"
KEY_ID = "NCWZ5SAFTZ"
private_key = OpenSSL::PKey.read(File.read("/Users/stherold/Downloads/AuthKey_#{KEY_ID}.p8"))

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