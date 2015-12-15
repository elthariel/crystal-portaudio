require "../src/portaudio"

puts LibPortAudio.get_version
puts String.new(LibPortAudio.get_version_text)

puts LibPortAudio.initialize
LibPortAudio.sleep( 1000 )
puts LibPortAudio.terminate
