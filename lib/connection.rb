module CloudMade
  # This +Connection+ class designed to provide connection to CloudMade services.
  # Normally you don't need to create it manually.
  # But sometimes it is useful to create connection
  # Connection examples:
  #
  # conn = CloudMade::Connection.new('cloudmade.com', 80, 'FAKE_API_KEY')
  # CloudMade.Client.new(conn)
  #
  class Connection
    attr_accessor :base_url
    attr_writer :port
    attr_accessor :api_key

    # Initializes connection
    # * +base_url+ should not start with 'www'
    # * +port+ integer value of port for CloudMade portal, if nil then default 80 port is used
    # * +api_key+ your API key to connect to CloudMade services
    def initialize(api_key = nil, base_url = 'cloudmade.com', port = nil)
      self.api_key = api_key
      self.base_url = base_url
      self.base_url = 'cloudmade.com' if self.base_url == nil or self.base_url.empty?
      self.port = port
    end

    #:nodoc:
    def connect(server_url, request)
      puts "#{server_url} #{request}"
      result = nil
      Net::HTTP.start(server_url, self.port) {|http|
        req = Net::HTTP::Get.new("#{request}")
        response = http.request(req)
        result = response.body
      }
      return result
    end

    #:nodoc:
    def url
      return "#{@base_url}#{@port != nil ? ':' + port.to_s : ''}"
    end

    #:nodoc:
    def port
      return 80 if @port == nil
      @port
    end
  end
end