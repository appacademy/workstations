# Hash-like singleton that controls access to the workstation settings.
# The settings are persisted to the recovery partition, and #save! and
# #restore! conrol this persistence. Using them requires root.

require 'yaml'
require 'singleton'
require_relative 'diskutil'

class Settings
  include Singleton

  LOCAL_FILE = File.expand_path("../../cache/settings.yaml", __FILE__)

  def recovery_volume
    Diskutil.recovery
  end

  def recovery_file
    return nil unless recovery_volume.mounted?

    File.join(recovery_volume.mount_point, ".aa_data.yaml")
  end

  def self.method_missing(*args)
    self.instance.send(*args)
  end

  def self.between_restore_and_save!(&blk)
    self.instance.between_restore_and_save!(&blk)
  end

  def method_missing(*args)
    @data.send(*args)
  end

  def local_data?
    saved? && !@data.empty?
  end

  def saved?
    File.exist?(LOCAL_FILE)
  end

  def persisted?
    File.exist?(recovery_file)
  end

  def restore!
    with_recovery_mounted do
      if persisted?
        restore
      else
        $stderr.puts "no data to restore"
        save_locally!
      end
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
    File.write(LOCAL_FILE, @data.to_yaml)
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
    `cp "#{recovery_file}" "#{LOCAL_FILE}"`
    @data = YAML.load_file(LOCAL_FILE)
  end

  def save
    File.write(recovery_file, @data.to_yaml)
    `cp "#{recovery_file}" "#{LOCAL_FILE}"`
  end

  def with_recovery_mounted
    recovery_volume.mount
    yield
  ensure
    recovery_volume.unmount
  end
end
