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

    raw_plist = DiskutilError.raise_if_fails("diskutil list -plist")
    plist = Plist.parse_xml(raw_plist)
    plist["AllDisksAndPartitions"].each do |device|
      add_disk_or_volume(device)
    end
  end

  def root
    @volumes.find(&:root?) || raise('root partition not found')
  end

  def backup
    @volumes.find(&:backup?) || raise('backup partition not found')
  end

  def recovery
    @volumes.find(&:recovery?) || raise('recovery partition not found')
  end

  def flash
    @volumes.find(&:flash?) || raise('flash drive not found')
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
  attr_reader :id, :name, :type, :mount_point

  def initialize(plist)
    state_from_plist(plist)
  end

  def uuid
    fetch_extra_state if @uuid.nil?
    @uuid
  end

  def usb?
    fetch_extra_state if @usb.nil?
    @protocol == 'USB'
  end

  def root?
    @mount_point == '/'
  end

  def backup?
    !root? && @type == 'Apple_HFS'
  end

  def recovery?
    @type == 'Apple_Boot'
  end

  def flash?
    @type == 'Apple_HFS' && usb?
  end

  def mounted?
    !@mount_point.nil?
  end

  def mount
    return @mount_point if mounted?

    DiskutilError.raise_if_fails("diskutil mount '#{@id}'")
    @mount_point = "/Volumes/#{@name}"
  end

  def unmount
    return unless mounted?

    DiskutilError.raise_if_fails("diskutil unmount '#{@id}'")
    @mount_point = nil
  end

  def with_mounted
    if mounted?
      yield
    else
      between_mount_and_unmount { yield }
    end
  end

  def between_mount_and_unmount
    mount
    yield
  ensure
    unmount
  end

  def erase
    raise "can only erase backup drive" unless backup?
    unmount
    DiskutilError.raise_if_fails("diskutil eraseVolume '#{@id}'")
  end

  def name=(name)
    return if @name == name

    DiskutilError.raise_if_fails("diskutil rename '#{id}' '#{name}'")
    @name = name
  end

  private

  def state_from_plist(plist)
    @id = plist['DeviceIdentifier']
    @name = plist['VolumeName']
    @type = plist['Content']
    @mount_point = plist['MountPoint']
    @uuid = plist['VolumeUUID']
    @protocol = plist['BusProtocol']
  end

  def fetch_extra_state
    raw_plist = DiskutilError.raise_if_fails("diskutil info -plist '#{@id}'")
    state_from_plist(Plist.parse_xml(raw_plist))
  end
end

class DiskutilError < RuntimeError

  def self.raise_if_fails(command)
    output = `#{command}`
    raise self, "`#{command}` failed" unless $?.success?
    output
  end
end
