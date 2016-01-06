#!/usr/bin/env ruby
# requires root privileges

require 'yaml'

DATA_FILE = "/Users/appacademy/.aa_data.yaml"

data = YAML.load_file(DATA_FILE)
id = data['id']
pod = data['pod']
station = data['station']

hostname = "AAStudent ##{id} (#{pod} #{station})"
local_hostname = "#{pod.downcase.gsub(' ', '-')}-#{station}"

puts hostname
puts local_hostname

`scutil --set ComputerName "#{hostname}"`
`scutil --set HostName "#{hostname}"`
`scutil --set LocalHostName "#{local_hostname}"`
`hostname #{local_hostname}`
