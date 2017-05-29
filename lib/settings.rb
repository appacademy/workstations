# Hash-like singleton that controls access to the workstation settings.
# The settings are saved to a file in the cache directory, but are also
# synced with the backup partition. #sync! and #restore! control the
# syncing.

require 'yaml'
require 'singleton'
require_relative 'diskutil'

class Settings
  include Singleton

  LOCAL_FILE = File.expand_path("../../cache/settings.yaml", __FILE__)

  def backup_volume
    Diskutil.backup
  end

  def backup_file
    return nil unless backup_volume.mounted?

    File.join(backup_volume.mount_point, LOCAL_FILE)
  end

  def backup_available?
    backup_volume.with_mounted do
      File.directory?(File.dirname(backup_file))
    end
  rescue RuntimeError, "backup partition not found"
    false
  end

  def self.method_missing(method_name, *args)
    if self.instance.respond_to?(method_name)
      self.instance.send(method_name, *args)
    else
      super
    end
  end

  def self.respond_to_missing?(method_name, include_private = false)
    self.instance.respond_to?(method_name) || super
  end

  def self.with_sync_or_save!(&blk)
    self.instance.with_sync_or_save!(&blk)
  end

  def method_missing(method_name, *args)
    if @data.respond_to?(method_name)
      @data.send(method_name, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @data.respond_to?(method_name) || super
  end

  def all
    @data.to_yaml
  end

  def local_data?
    saved? && !@data.empty?
  end

  def saved?
    File.exist?(LOCAL_FILE)
  end

  def backup_exists?
    File.exist?(backup_file)
  end

  def restore!
    backup_volume.with_mounted do
      if backup_exists?
        restore
      else
        warn "no data to restore"
        save!
      end
    end
  end

  def sync!
    backup_volume.with_mounted do
      sync
    end
  end

  def save!
    # settings saved this way will be overwritten the next time
    # settings are saved or restored.
    File.write(LOCAL_FILE, @data.to_yaml)
  end

  def between_restore_and_sync!
    backup_volume.with_mounted do
      restore
      yield
      sync
    end
  end

  def with_sync_or_save!
    if backup_available?
      backup_volume.with_mounted do
        restore
        yield
        sync
      end
    else
      warn 'Unable to sync. Backup not available.'
      yield
      save!
    end
  end

  private

  def initialize
    @data = saved? ? YAML.load_file(LOCAL_FILE) : {}
  end

  def restore
    `cp "#{backup_file}" "#{LOCAL_FILE}"`
    @data = YAML.load_file(LOCAL_FILE)
  end

  def sync
    File.write(LOCAL_FILE, @data.to_yaml)
    `cp "#{LOCAL_FILE}" "#{backup_file}"`
  end
end
