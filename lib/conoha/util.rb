require 'net/https'
require 'uri'

# @return [Net::HTTPResponse]
# @params [String] uri_string URI string
# @params [String] authtoken
def https_get(uri_string, authtoken)
  uri = URI.parse uri_string
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = Net::HTTP::Get.new(uri.path)
  req['Content-Type'] = 'application/json'
  req['Accept'] = 'application/json'
  req['X-Auth-Token'] = authtoken
  https.request(req)
end

# @return [Net::HTTPResponse]
# @params [String] uri_string URI string
# @params [Hash] payload HTTP request body
# @params [String|nil] authtoken
#   Authtoken string or `nil`.
#   Can pass `nil` only on authenticating with username and password.
def https_post(uri_string, payload, authtoken)
  uri = URI.parse uri_string
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = Net::HTTP::Post.new(uri.request_uri)
  req['Content-Type'] = 'application/json'
  req['Accept'] = 'application/json'
  req['X-Auth-Token'] = authtoken
  req.body = payload.to_json
  https.request(req)
end

# @return [Net::HTTPResponse]
# @params [String] uri_string URI string
# @params [String] authtoken
def https_delete(uri_string, authtoken)
  uri = URI.parse uri_string
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = Net::HTTP::Delete.new(uri.request_uri)
  req['Content-Type'] = 'application/json'
  req['Accept'] = 'application/json'
  req['X-Auth-Token'] = authtoken
  https.request(req)
end

# @params [Array<String>]
#   The return value of `ip_address_of` method. It is either
#
#       ["111.111.111.111", "1111:1111:1111:1111:1111:1111:1111:1111"]
#
#   or
#
#       ["1111:1111:1111:1111:1111:1111:1111:1111", "111.111.111.111"]
#
# @return [String] IPv4 address (e.g. "111.111.111.111")
def ipv4(ip_address)
  ip_address.select { |e| e =~ /\d+\.\d+\.\d+\.\d+/ }.first
end

# @return [String] UUID of image
# @params [String] os OS name
# @raise [StandardError] When the OS name isn't be contained.
def image_ref_from_os(os)
  dictionary = {
    'ubuntu'   => '4952b4e5-67bb-4f84-991f-9f3f1647d63d', # Ubuntu 14.04 amd64
    'centos66' => '14961158-a69c-4af1-b375-b9a72982837d', # CentOS 6.6
    'centos67' => '91944101-df61-4c41-b7c5-76cebfc48318', # CentOS 6.7
    'centos71' => 'edc9457e-e4a8-4974-8217-c254d215b460', # CentOS 7.1
    'arch'     => 'fe22a9e4-8ba1-4ea3-90ce-d59d5e5b35b9', # Arch
  }
  if dictionary.keys.include? os
    dictionary[os]
  else
    raise StandardError.new <<EOS
Select os name from the following list:

#{dictionary.keys.join("\n")}
EOS
  end
end
