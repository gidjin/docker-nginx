require "faraday"

class EtcdUpdater

  def initialize(service_name, hostname, ttl = 60, etcd = "127.0.0.1:4001", scheme = "http")
    @service_name = service_name
    @hostname = hostname
    @ttl = ttl
    @etcd_url = "#{scheme}://#{etcd}"
    @connection = Faraday.new(url: @etcd_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def update_config
    container_ip = `cat /etc/hosts | head -1`.match(%r|^(\d+\.\d+\.\d+\.\d+).*|)[1]
    main_domain = ENV["MAIN_DOMAIN"]
    aliases = ENV["ALIAS_DOMAINS"] || nil

    raise "No main domain set" unless main_domain
    raise "No container ip" unless container_ip

    # Add main domain key
    @connection.put do |req|
      req.url "/v2/keys/services/web/#{@service_name}/main_domain"
      req.params["value"] = ENV["MAIN_DOMAIN"]
      req.params["ttl"] = @ttl
    end

    # Add server ip
    @connection.put do |req|
      req.url "/v2/keys/services/web/#{@hostname}/servers"
      req.params["value"] = "{ \"ip\":\"#{container_ip}\", \"port\":\"80\" }"
      req.params["ttl"] = @ttl
    end

    # Add aliases
    @connection.put do |req|

    end
  end
end
