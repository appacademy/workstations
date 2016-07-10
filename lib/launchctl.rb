require 'plist'

class LaunchctlConfig
  CONFIG_DIR = nil

  attr_reader :name

  def self.remove_all
    Dir.foreach(self::CONFIG_DIR) do |file|
      name = name_from_file(file)
      new(name).uninstall if name
    end
  end

  def self.name_from_file(filename)
    match = /com\.workstation\.(.+)\.plist/.match(filename)
    match && match[1]
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

  def load_config
    @config = Plist.parse_xml(config_path)
  end

  def install
    File.write(config_path, to_plist)

    `launchctl unload #{config_path} 2> /dev/null`
    `launchctl load #{config_path}`
  end

  def uninstall
    `launchctl unload #{config_path} 2> /dev/null`
    File.delete(config_path)
  end

  def label
    "com.workstation.#{@name}"
  end

  private

  def config_path
    File.join(self.class::CONFIG_DIR, "#{label}.plist")
  end
end

class LaunchDaemon < LaunchctlConfig
  CONFIG_DIR = '/Library/LaunchDaemons'.freeze
end

class LaunchAgent < LaunchctlConfig
  CONFIG_DIR = '/Library/LaunchAgents'.freeze
end

class UserLaunchAgent < LaunchctlConfig
  home = ENV['USER'] == 'root' ? '/Users/appacademy' : ENV['HOME']
  CONFIG_DIR = File.join(home, 'Library/LaunchAgents').freeze
end
