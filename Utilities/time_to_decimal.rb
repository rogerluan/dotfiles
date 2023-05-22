# Converts time from a "hour:minute:second" format to decimal.
# Usage: `ruby hour_to_decimal.rb 12:34:56`
# Prints out: 12.582222222222223

time_string = ARGV[0]
time_components = time_string.split(":").map(&:to_f)
seconds = time_components[2] / 3600.0
minutes = time_components[1] / 60.0
hour = time_components[0]
decimal_result = hour + minutes + seconds
puts(decimal_result)
