#!/usr/bin/env ruby
require 'yaml'

USER = "appacademy"
RECOVERY_FILE = "/Volumes/Recovery HD/.aa_data.yaml"
LOCAL_FILE = "/Users/#{USER}/.aa_data.yaml"

def with_recovery_mounted
  `diskutil mount /dev/disk0s3`
  yield
ensure
  `diskutil unmount /dev/disk0s3`
end

def restore_data
  `cp "#{RECOVERY_FILE}" "#{LOCAL_FILE}"`
  `chown "#{USER}" #{LOCAL_FILE}`
end

def save_data(args)
  data = parse_args(args)
  update_yaml(data)
  restore_data
end

def parse_args(args)
  data = {}
  args.each do |arg|
    key, value = arg.split('=')
    data[key] = value
  end
  data
end

def update_yaml(new_data)
  data = File.exist?(RECOVERY_FILE) ? YAML::load_file(RECOVERY_FILE) : {}
  data.update(new_data)
  File.open(RECOVERY_FILE, 'w') { |f| f.write data.to_yaml }
end

with_recovery_mounted do
  case ARGV[0]
  when 'restore'
    restore_data
  when /save|set/
    save_data(ARGV.drop(1))
  else
    raise 'Invalid argument. Must be "restore" or "save".'
  end
end
