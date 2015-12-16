require "./portaudio/*"

module Pa
  def self.version
    LibPortAudio.get_version
  end

  def self.version_text
    String.new LibPortAudio.get_version_text
  end

end

alias PortAudio = Pa
