require "./lib"
require "./host_api"

module Pa
  class Device
    delegate :max_input_channels, :max_output_channels, @info
    delegate :default_low_input_latency, :default_low_output_latency, @info
    delegate :default_high_input_latency, :default_high_output_latency, @info
    delegate :default_sample_rate, @info
    getter id

    def initialize(@id, @info)
    end

    def name
      String.new @info.name
    end

    def host_api
      HostApi.by_id @info.host_api
    end

    # Class Methods
    def self.by_id(idx)
      info = LibPortAudio.get_device_info(idx)
      raise IndexError.new("Unknown device ###{idx}") if info.null?
      new idx, info.value
    end

    def self.default_input
      idx = LibPortAudio.get_default_input_device
      by_id idx
    end

    def self.default_output
      idx = LibPortAudio.get_default_output_device
      by_id idx
    end

    def self.all
      count = LibPortAudio.get_device_count
      (0...count).map { |idx| by_id idx }
    end
  end
end
