require_relative "etcd_updater"

updater = EtcdUpdater.new(ENV['HOSTNAME'], 60, ENV['ETCD'])

loop do
  updater.update_config
  sleep(45)
end
