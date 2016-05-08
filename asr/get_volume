#!/usr/bin/env ruby

def asr_devices
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

  devices
end

puts asr_devices[ARGV[0]] if __FILE__ == $PROGRAM_NAME
