require "../src/portaudio"

puts "#{Pa.version_text} [#{Pa.version}]"

LibPortAudio.initialize

puts "Listing known Host APIs:"
apis = Pa::HostApi.all
apis.each do |api|
  puts "- #{api.name}"
end

puts "Listing Devices"
devices = Pa::Device.all
devices.each do |device|
  api = device.host_api
  puts "- ##{device.id}: #{api.name}: #{device.name}"
end

LibPortAudio.terminate
