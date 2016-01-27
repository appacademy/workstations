#!/usr/bin/env ruby
# requires root privileges

require 'yaml'

DATA_FILE = "/Users/appacademy/.aa_data.yaml"

data = YAML.load_file(DATA_FILE)
id = data['id']
pod = data['pod']
station = data['station']

hostname = "AAStudent #{pod} #{station} (##{id})"
local_hostname = "aa-#{pod.downcase.tr(' ', '-')}-#{station}-id#{id}"

`scutil --set ComputerName "#{hostname}"`
`scutil --set HostName "#{hostname}"`
`scutil --set LocalHostName "#{local_hostname}"`
`hostname #{local_hostname}`
