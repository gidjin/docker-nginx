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

    @container_ip = `cat /etc/hosts | head -1`.match(%r|^(\d+\.\d+\.\d+\.\d+).*|)[1]
    @main_domain = ENV["MAIN_DOMAIN"]
    @aliases = ENV["ALIAS_DOMAINS"] || nil

    raise "No main domain set" unless @main_domain
    raise "No container ip" unless @container_ip
  end

  def update_config
    # Add server ip
    @connection.put do |req|
      req.url "/v2/keys/services/web/#{@main_domain}/servers/#{@hostname}"
      req.params["value"] = "{ \"ip\":\"#{@container_ip}\", \"port\":\"80\" }"
      req.params["ttl"] = @ttl
    end

    # Add aliases
    if !@aliases.nil?
      @connection.put do |req|
        req.url "/v2/keys/services/web/#{@main_domain}/aliases"
        req.params["value"] = @aliases
        req.params["ttl"] = @ttl
      end
    end
  end
end
