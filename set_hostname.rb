#!/usr/bin/env ruby
# requires root privileges

require 'yaml'
require 'active_support/inflector'

DATA_FILE = "/Users/appacademy/.aa_data.yaml"

data = YAML.load_file(DATA_FILE)
name = "AAStudent ##{data['id']} (#{data['pod']} #{data['station']})"

`scutil --set ComputerName "#{name}"`
`scutil --set HostName "#{name}"`
`scutil --set LocalHostName "#{name.parameterize}"`
`hostname #{name.parameterize}`
