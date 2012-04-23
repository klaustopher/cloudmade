$:.push File.expand_path("../../lib", __FILE__)
$:.push File.expand_path("../..", __FILE__)

require 'cloudmade'

class MockConnection < CloudMade::Connection
  attr_accessor :return_data
  attr_accessor :request
  attr_accessor :server_url

  def connect(server_url, request)
    self.request = request
    self.server_url = server_url
    return return_data
  end
end