require_relative "etcd_updater"

updater = EtcdUpdater.new("nginx", ENV['HOSTNAME'], 60, "#{ENV['HOST_IP']}:#{ENV['PORT']}")

loop do
  updater.update_config
  sleep(45)
end
