#!/usr/bin/env ruby

def get_device(type)
  devices = {}

  `mount`.lines.each do |line|
    match = line.match(/(?<device>\/dev\/disk\w+) on (?<mount_point>\S+)/)
    next if not match

    if match['mount_point'] == '/'
      devices['root'] = match['device']
    else
      devices['restore'] = match['device']
    end

    return devices[type]
  end
end

def get_volume_name(volume)
  match = `diskutil info #{volume}`.match(/Volume Name: +([\S ]+)/)
  return match[1] if match
end

if ['root', 'restore'].include?(ARGV[0])
  puts get_device(ARGV[0])
else
  puts get_volume_name(ARGV[0])
end
