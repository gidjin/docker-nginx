#!/usr/bin/env ruby

require "daemons"


# Become a daemon
Daemons.run("etcd_updater_process.rb")

