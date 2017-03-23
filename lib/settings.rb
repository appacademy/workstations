# Hash-like singleton that controls access to the workstation settings.
# The settings are persisted to the backup partition, and #save! and
# #restore! control this persistence. Using them requires root.

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

  def self.between_restore_and_save!(&blk)
    self.instance.between_restore_and_save!(&blk)
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

  def persisted?
    File.exist?(backup_file)
  end

  def restore!
    with_backup_mounted do
      if persisted?
        restore
      else
        $stderr.puts "no data to restore"
        save_locally!
      end
    end
  end

  def save!
    with_backup_mounted do
      save
    end
  end

  def save_locally!
    # settings saved this way will be overwritten the next time
    # settings are saved or restored.
    File.write(LOCAL_FILE, @data.to_yaml)
  end

  def between_restore_and_save!
    with_backup_mounted do
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
    if persisted?
      `cp "#{backup_file}" "#{LOCAL_FILE}"`
      @data = YAML.load_file(LOCAL_FILE)
    end
  end

  def save
    File.write(backup_file, @data.to_yaml)
    `cp "#{backup_file}" "#{LOCAL_FILE}"`
  end

  def with_backup_mounted
    backup_volume.mount
    yield
  ensure
    backup_volume.unmount
  end
end
