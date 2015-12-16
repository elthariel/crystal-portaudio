module Pa
  alias Error = Int32
  alias DeviceIndex = Int32
  alias HostApiIndex = Int32
  alias Time = Float64

  enum ErrorCode : Int32
    NoError = 0

    NotInitialized = -10000
    UnanticipatedHostError
    InvalidChannelCount
    InvalidSampleRate
    InvalidDevice
    InvalidFlag
    SampleFormatNotSupported
    BadIODeviceCombination
    InsufficientMemory
    BufferTooBig
    BufferTooSmall
    NullCallback
    BadStreamPtr
    TimedOut
    InternalError
    DeviceUnavailable
    IncompatibleHostApiSpecificStreamInfo
    StreamIsStopped
    StreamIsNotStopped
    InputOverflowed
    OutputUnderflowed
    HostApiNotFound
    InvalidHostApi
    CanNotReadFromACallbackStream
    CanNotWriteToACallbackStream
    CanNotReadFromAnOutputOnlyStream
    CanNotWriteToAnInputOnlyStream
    IncompatibleStreamHostApi
    BadBufferPtr

    def to_s
      String.new(LibPortAudio.get_error_text self)
    end
  end

  enum HostApiType : Int32
    InDevelopment = 0
    DirectSound = 1
    MME = 2
    ASIO = 3
    SoundManager = 4
    CoreAudio = 5
    OSS = 7
    ALSA = 8
    AL = 9
    BeOS = 10
    WDMKS = 11
    JACK = 12
    WASAPI = 13
    AudioScienceHPI = 14
  end

  @[Flags]
  enum SampleFormat: UInt64
    Float32
    Int32
    Int24
    Int16
    Int8
    UInt8
    CustomFormat    = 0x00010000
    NonInterleaved  = 0x80000000
  end

  @[Flags]
  enum StreamFlags : UInt64
    NoFlag = 0
    ClipOff = 1
    DitherOff
    NeverDropInput
    PrimeOutputBuffersUsingStreamCallback
    PlatformSpecificFlag = 0xFFFF0000
  end

  @[Flags]
  enum StreamCallbackFlags : UInt64
    InputUnderflow
    InputOverflow
    OutputUnderflow
    OutputOverflow
    PrimingOutput
  end

  enum StreamCallbackResult
    Continue = 0
    Complete = 1
    Abort = 2
  end
end

@[Link("portaudio")]
lib LibPortAudio
  struct HostApiInfo
    struct_version : Int32
    type : Pa::HostApiType
    name : UInt8*
    device_count : Int32
    default_input_device : Pa::DeviceIndex
    default_output_defice : Pa::DeviceIndex
  end

  struct HostErrorInfo
    host_api_type : Pa::HostApiType
    error_code : Int32
    error_text : UInt8*
  end

  struct DeviceInfo
    struct_version : Int32
    name : UInt8*
    host_api : Pa::HostApiIndex
    max_input_channels : Int32
    max_output_channels : Int32
    default_low_input_latency : Pa::Time
    default_low_output_latency : Pa::Time
    default_high_input_latency : Pa::Time
    default_high_output_latency : Pa::Time
    default_sample_rate : Float64
  end

  struct StreamParameters
    device : Pa::DeviceIndex
    channel_count : Int32
    sample_format : Pa::SampleFormat
    suggested_latency : Pa::Time
    host_api_specific_stream_info : Void*
  end

  struct StreamCallbackTimeInfo
    input_buffer_adc_time : Pa::Time
    current_time : Pa::Time
    output_buffer_dac_time : Pa::Time
  end

  struct StreamInfo
    struct_version : Int32
    input_latency : Pa::Time
    output_latency : Pa::Time
    sample_rate : Float64
  end

  type StreamCallback = (Void*, Void*, UInt64, StreamCallbackTimeInfo*,\
                         Pa::StreamCallbackFlags, Void*) -> Pa::StreamCallbackResult
  type StreamFinishedCallback = Void* -> Void

  type Stream = Void*

  # Basic info
  fun get_version = Pa_GetVersion() : Int32
  fun get_version_text = Pa_GetVersionText() : UInt8*
  fun get_error_text = Pa_GetErrorText(Pa::ErrorCode) : UInt8*

  # Initialize / Terminate
  fun initialize = Pa_Initialize(): Pa::ErrorCode
  fun terminate = Pa_Terminate(): Pa::ErrorCode

  # Host Api
  fun get_host_api_count = Pa_GetHostApiCount() : Pa::HostApiIndex
  fun get_default_host_api = Pa_GetDefaultHostApi() : Pa::HostApiIndex
  fun get_host_api_info = Pa_GetHostApiInfo(index : Pa::HostApiIndex) : HostApiInfo*
  fun host_api_type_id_to_host_api_index =
      Pa_HostApiTypeIdToHostApiIndex(type : Pa::HostApiType) : Pa::HostApiIndex
  fun host_api_device_index_to_device_index =
      Pa_HostApiDeviceIndexToDeviceIndex(host_api : Pa::HostApiIndex,
                                         host_api_index : Int32) : Pa::DeviceIndex
  fun get_last_host_error_info = Pa_GetLastHostErrorInfo() : HostErrorInfo*

  # Device Enumeration
  fun get_device_count = Pa_GetDeviceCount() : Pa::DeviceIndex
  fun get_default_input_device = Pa_GetDefaultInputDevice() : Pa::DeviceIndex
  fun get_default_output_device = Pa_GetDefaultOutputDevice() : Pa::DeviceIndex
  fun get_device_info = Pa_GetDeviceInfo(index : Pa::DeviceIndex) : DeviceInfo*

  # Streams
  fun is_format_supported = Pa_IsFormatSupported(input_params : StreamParameters*,
                                                 output_params : StreamParameters*,
                                                 sample_rate : Float64) : Pa::ErrorCode
  fun open_stream = Pa_OpenStream(stream : Stream*, input_params : StreamParameters,
                                  output_params : StreamParameters, sample_rate : Float64,
                                  samples : UInt64, stream_flags : Pa::StreamFlags,
                                  callback : StreamCallback*, user_data : Void*) : Pa::ErrorCode
  fun open_default_stream = Pa_OpenDefaultStream(stream : Stream*,
                                                 num_in_channels : Int32,
                                                 num_out_channels : Int32,
                                                 sample_format : Pa::SampleFormat,
                                                 sample_rate : Float32,
                                                 frames_per_buffer : UInt64,
                                                 callback : StreamCallback,
                                                 user_data : Void*) : Pa::ErrorCode
  fun close_stream = Pa_CloseStream(stream : Stream) : Pa::ErrorCode
  fun set_stream_finished_callback = Pa_SetStreamFinishedCallback(stream : Stream,
                                        cbk : StreamFinishedCallback*) : Pa::ErrorCode
  fun start_stream = Pa_StartStream(stream : Stream) : Pa::ErrorCode
  fun stop_stream = Pa_StopStream(stream : Stream) : Pa::ErrorCode
  fun abort_stream = Pa_AbortStream(stream : Stream) : Pa::ErrorCode
  fun is_stream_stopped? = Pa_IsStreamStopped(stream : Stream) : Pa::Error
  fun is_stream_active? = Pa_IsStreamActive(stream : Stream) : Pa::Error
  fun get_stream_info = Pa_GetStreamInfo(stream : Stream) : StreamInfo*
  fun get_stream_time = Pa_GestStreamTime(stream : Stream) : Pa::Time
  fun get_stream_cpu_load = Pa_GestStreamCpuLoad(stream : Stream) : Float64

  # Streams IO
  fun read_stream = Pa_ReadStream(stream : Stream, buffer : Void*,
                                  frames : UInt64) : Pa::ErrorCode
  fun write_stream = Pa_WriteStream(stream : Stream, buffer : Void*,
                                    frames : UInt64) : Pa::ErrorCode
  fun stread_read_available = Pa_GetStreamReadAvailable(stream : Stream) : Int64
  fun stread_write_available = Pa_GetStreamWriteAvailable(stream : Stream) : Int64

  # Misc utilities
  fun get_sample_size(format : Pa::SampleFormat) : Pa::ErrorCode
  fun sleep = Pa_Sleep(msec : Int32) : Void
end
