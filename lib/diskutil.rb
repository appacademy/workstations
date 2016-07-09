require 'plist'
require 'singleton'

class Diskutil
  include Singleton

  attr_reader :volumes

  def self.method_missing(*args)
    self.instance.send(*args)
  end

  def initialize
    @volumes = []

    plist = Plist.parse_xml(`diskutil list -plist`)
    plist["AllDisksAndPartitions"].each do |device|
      add_disk_or_volume(device)
    end
  end

  def root
    @volumes.find(&:root?)
  end

  def backup
    @volumes.find(&:backup?)
  end

  def recovery
    @volumes.find(&:recovery?)
  end

  alias restore backup

  private

  def add_disk_or_volume(device)
    if device["Partitions"]
      device["Partitions"].each { |volume| add_volume(volume) }
    else
      add_volume(device)
    end
  end

  def add_volume(plist)
    @volumes << Volume.new(plist)
  end

end

class Volume
  attr_reader :id, :name, :uuid, :filesystem, :mount_point

  def initialize(plist)
    @id = plist['DeviceIdentifier']
    @name = plist['VolumeName']
    @filesystem = plist['Content']
    @mount_point = plist['MountPoint']
  end

  def root?
    @mount_point == '/'
  end

  def backup?
    !root? && @filesystem == 'Apple_HFS'
  end

  def recovery?
    @filesystem == 'Apple_Boot'
  end

  def mounted?
    !@mount_point.nil?
  end

  def mount
    return @mount_point if mounted?

    `diskutil mount "#{@id}"`
    @mount_point = "/Volumes/#{@name}"
  end

  def unmount
    return unless mounted?

    `diskutil unmount "#{@id}"`
    @mount_point = nil
  end

  def erase
    raise "can only erase backup drive" unless backup?
    unmount
    `diskutil eraseVolume "#{@id}"`
  end

  def name=(name)
    return if @name == name

    `diskutil rename "#{id}" "#{name}"`
    @name = name
  end
end
