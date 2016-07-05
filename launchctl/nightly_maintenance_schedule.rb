module MaintenanceSchedule
  HOUR = 4
  MINUTE = 45
  WEEKDAYS = (1..5)

  def self.set_wake_times
    `pmset repeat wakeorpoweron MTWRF #{_zpad(HOUR)}:#{_zpad(MINUTE)}:00`
  end

  def self._zpad(int)
    '%.02i' % int
  end
end
