# Hash-like singleton that controls access to the workstation settings.
# The settings are persisted to the recovery partition, and #save! and
# #restore! conrol this persistence. Using them requires root.

require 'yaml'
require 'singleton'

class Settings
  include Singleton

  RECOVERY_VOLUME = "Recovery HD".freeze
  RECOVERY_FILE = "/Volumes/#{RECOVERY_VOLUME}/.aa_data.yaml".freeze
  LOCAL_FILE = "#{File.dirname(__FILE__)}/cache/settings.yaml".freeze

  def self.method_missing(*args)
    self.instance.send(*args)
  end

  def self.between_restore_and_save!(&blk)
    self.instance.between_restore_and_save!(&blk)
  end

  def method_missing(*args)
    @data.send(*args)
  end

  def saved?
    File.exist?(LOCAL_FILE)
  end

  def restore!
    with_recovery_mounted do
      restore
    end
  end

  def save!
    with_recovery_mounted do
      save
    end
  end

  def save_locally!
    # settings saved this way will be overwritten the next time
    # settings are saved or restored.
    File.open(LOCAL_FILE, 'w') { |f| f.write @data.to_yaml }
  end

  def between_restore_and_save!
    with_recovery_mounted do
      restore
      yield
      save
    end
  end

  private

  def initialize
    @data = saved? ? YAML.load_file(LOCAL_FILE) : {}
  end

  def restore
    `cp "#{RECOVERY_FILE}" "#{LOCAL_FILE}"`
    @data = YAML.load_file(LOCAL_FILE)
  end

  def save
    File.open(RECOVERY_FILE, 'w') { |f| f.write @data.to_yaml }
    `cp "#{RECOVERY_FILE}" "#{LOCAL_FILE}"`
  end

  def with_recovery_mounted
    `diskutil mount "#{RECOVERY_VOLUME}"`
    yield
  ensure
    `diskutil unmount "#{RECOVERY_VOLUME}"`
  end
end
