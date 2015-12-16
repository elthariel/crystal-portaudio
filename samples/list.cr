require "../src/portaudio"

puts LibPortAudio.get_version
puts String.new(LibPortAudio.get_version_text)

puts LibPortAudio.initialize

count = LibPortAudio.get_host_api_count
i = 0
while i < count
  info = LibPortAudio.get_host_api_info(i)
  puts info.value
  i += 1
end

puts LibPortAudio.terminate
