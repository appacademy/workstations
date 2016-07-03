HOUR = 4
MINUTE = 45
WEEKDAYS = (1..5)

# Schedule machines to wake up for maintenance. This is here so that all
# the schedule configuration is in the same file
`pmset repeat wakeorpoweron MTWRF 4:45:00` if __FILE__ == $PROGRAM_NAME
