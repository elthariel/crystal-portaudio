module Pa
  alias DeviceIndex = Int32
  alias HostApiIndex = Int32
  alias Time = Float64

  enum Error : Int32
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
  enum SampleFormat: UInt32
    Float32
    Int32
    Int24
    Int16
    Int8
    UInt8
    CustomFormat    = 0x00010000
    NonInterleaved  = 0x80000000
  end
end

@[Link("portaudio")]
lib LibPortAudio
  fun get_version = Pa_GetVersion() : Int32
  fun get_version_text = Pa_GetVersionText() : UInt8*

  fun get_error_text = Pa_GetErrorText(Pa::Error) : UInt8*

  fun initialize = Pa_Initialize(): Pa::Error
  fun terminate = Pa_Terminate(): Pa::Error

  fun get_host_api_count = Pa_GetHostApiCount() : Pa::HostApiIndex
  fun get_default_host_api = Pa_GetDefaultHostApi() : Pa::HostApiIndex

  # ...

  fun get_device_count = Pa_GetDeviceCount() : Pa::DeviceIndex
  fun get_default_input_device = Pa_GetDefaultInputDevice() : Pa::DeviceIndex
  fun get_default_output_device = Pa_GetDefaultOutputDevice() : Pa::DeviceIndex

  fun sleep = Pa_Sleep(msec : Int32) : Void
end
