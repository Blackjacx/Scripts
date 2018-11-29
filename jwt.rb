require "base64"
require "jwt"
ISSUER_ID = "69a6de91-fecb-47e3-e053-5b8c7c11a4d1"
KEY_ID = "6CG495GK76"
private_key = OpenSSL::PKey.read(File.read("~/Downloads/AuthKey_6CG495GK76.p8"))

