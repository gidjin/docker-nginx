require "faraday"

class EtcdUpdater
  def initialize(hostname, ttl = 60, etcd = "127.0.0.1:4001", scheme = "http")
    @hostname = hostname
    @ttl = ttl
    @etcd_url = "#{scheme}://#{etcd}"
    @connection = Faraday.new(url: @etcd_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    @container_ip = `hostname --ip`.chomp!
    @name = ENV["NAME"] || nil

    raise "No container ip" unless @container_ip
    raise "No hostname set" unless @hostname

    @path = "/v2/keys/services/web"
    @path += "/#{@name}" if @name

    @server_name = ENV["SERVER_NAME"] || @name
    @server_aliases = ENV["SERVER_ALIASES"] || nil
  end

  def update_config
    # Add server ip
    @connection.put do |req|
      req.url "#{@path}/servers/#{@hostname}"
      req.params["value"] = @container_ip
      req.params["ttl"] = @ttl
    end

    if @server_name
      @connection.put do |req|
        req.url "#{@path}/server_name"
        req.params["value"] = @server_name
        req.params["ttl"] = @ttl
      end
    end

    if @server_aliases
      @connection.put do |req|
        req.url "#{@path}/server_aliases"
        req.params["value"] = @server_aliases
        req.params["ttl"] = @ttl
      end
    end
  end
end
