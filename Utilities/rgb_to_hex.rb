def rgb_to_hex(rgb_string)
  # Split the string by comma, remove any leading/trailing whitespace from each component
  rgb_values = rgb_string.split(',').map(&:strip).map(&:to_i)

  # Ensure there are exactly three components for R, G, and B
  raise ArgumentError, 'Invalid RGB input' unless rgb_values.size == 3

  # Convert each component to a hexadecimal string and concatenate them
  hex_color = rgb_values.map { |value| value.clamp(0, 255).to_s(16).rjust(2, '0') }.join

  "##{hex_color.upcase}"
end

rgb_input = ARGV[0]
puts rgb_to_hex(rgb_input)
