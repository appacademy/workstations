#!/usr/bin/env ruby

def get_device_by_type(type)
  devices = {}

  `mount`.lines.each do |line|
    match = line.match(%r{(?<device>/dev/disk\w+) on (?<mount_point>\S+)})
    next unless match

    if match['mount_point'] == '/'
      devices['root'] = match['device']
    else
      devices['restore'] = match['device']
    end
  end

  devices[type]
end

def get_device_by_name(volume)
  match = `diskutil info "#{volume}"`.match(%r{Device Node: +(/.+)})
  return match[1] if match
end

if __FILE__ == $PROGRAM_NAME
  case ARGV[0]
  when 'type'
    puts get_device_by_type(ARGV[1])
  when 'name'
    puts get_device_by_name(ARGV[1])
  end
end
