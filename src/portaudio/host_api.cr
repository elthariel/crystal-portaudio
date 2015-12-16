require "./lib"

module Pa
  class HostApi
    delegate :device_count, :default_input_device, :default_output_device, :type, @info

    def initialize(@info)
    end

    def name
      String.new(@info.name)
    end

    def self.by_id(idx)
      info = LibPortAudio.get_host_api_info(idx)
      raise IndexError.new("Unkown Host API with index #{idx}") if info.null?
      new info.value
    end

    def self.default
      idx = LibPortAudio.get_default_host_api
      by_id idx
    end

    def self.all
      count = LibPortAudio.get_host_api_count
      (0...count).map { |idx| by_id idx }
    end
  end
end
