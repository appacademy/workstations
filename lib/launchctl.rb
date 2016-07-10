require 'plist'

class LaunchctlConfig
  CONFIG_DIR = nil

  attr_reader :name

  def self.remove_all
    Dir.foreach(self::CONFIG_DIR) do |file|
      if File.basename(file)[0...16] == 'com.workstation.'
        `launchctl unload #{file} 2> /dev/null`
        File.delete(file)
      end
    end
  end

  def initialize(name)
    @name = name
    @config = { Label: label }
  end

  def to_plist
    @config.to_plist
  end

  def [](key)
    @config[key]
  end

  def []=(key, value)
    @config[key] = value
  end

  def configure(config)
    @config.update(config)
  end

  def install
    File.write(config_path, to_plist)

    `launchctl unload #{config_path} 2> /dev/null`
    `launchctl load #{config_path}`
  end

  def label
    "com.workstation.#{@name}"
  end

  private

  def config_path
    File.join(self.class::CONFIG_DIR, "#{label}.plist")
  end
end

class LaunchDaemon < LaunchDConfig
  CONFIG_DIR = '/Library/LaunchDaemons'.freeze
end

class RootLaunchAgent < LaunchDConfig
  CONFIG_DIR = '/Library/LaunchAgents'.freeze
end

_home = ENV['USER'] == 'root' ? '/Users/appacademy' : ENV['HOME']

class UserLaunchAgent < LaunchDConfig
  CONFIG_DIR = File.join(_home, 'Library/LaunchAgents').freeze
end
