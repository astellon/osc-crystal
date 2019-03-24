# Decoding argument value from Array(UInt8)
module OSC::Decode
  extend self

  def decode(type : UInt32.class, x : Array(UInt8), offset : Int = 0)
    y = 0_u32
    y |= x[offset + 3].to_u32
    y |= x[offset + 2].to_u32 << 8
    y |= x[offset + 1].to_u32 << 16
    y |= x[offset].to_u32 << 24
  end

  def decode(type : Int32.class, x : Array(UInt8), offset : Int = 0)
    y = 0_i32
    y |= x[offset + 3].to_i32
    y |= x[offset + 2].to_i32 << 8
    y |= x[offset + 1].to_i32 << 16
    y |= x[offset].to_i32 << 24
  end

  def decode(type : Int64.class, x : Array(UInt8), offset : Int = 0)
    y = 0_i64
    y |= x[offset + 7].to_i64
    y |= x[offset + 6].to_i64 << 8
    y |= x[offset + 5].to_i64 << 16
    y |= x[offset + 4].to_i64 << 24
    y |= x[offset + 3].to_i64 << 32
    y |= x[offset + 2].to_i64 << 40
    y |= x[offset + 1].to_i64 << 48
    y |= x[offset].to_i64 << 56
  end

  def decode(type : Float32.class, x : Array(UInt8), offset : Int = 0)
    decode(Int32, x, offset).unsafe_as(Float32)
  end

  def decode(type : Float64.class, x : Array(UInt8), offset : Int = 0)
    decode(Int64, x, offset).unsafe_as(Float64)
  end

  def decode(type : String.class, x : Array(UInt8), offset : Int = 0)
    String.new(x.to_unsafe + offset)
  end

  def decode(type : Char.class, x : Array(UInt8), offset : Int = 0)
    x[offset + 3].unsafe_chr
  end

  def decode(type : Array(UInt8).class, x : Array(UInt8), offset : Int = 0)
    size = OSC::Decode.decode(Int32, x, offset)
    x[offset + 4, size]
  end

  def decode(type : Time.class, x : Array(UInt8), offset : Int = 0)
    sec = OSC::Decode.decode(UInt32, x, offset)
    nano = OSC::Decode.decode(UInt32, x, offset + 4) * 200 / 1000
    Time.utc(1900, 1, 1) + Time::Span.new(seconds: sec, nanoseconds: nano)
  end

  def decode(type : OSC::Type::RGBA.class, x : Array(UInt8), offset : Int = 0)
    OSC::Type::RGBA.new(x[offset], x[offset + 1], x[offset + 2], x[offset + 3])
  end

  def decode(type : OSC::Type::Midi.class, x : Array(UInt8), offset : Int = 0)
    OSC::Type::Midi.new(x[offset, 4])
  end

  def decode(type : OSC::Type::True.class, x : Array(UInt8), offset : Int = 0)
    true
  end

  def decode(type : OSC::Type::False.class, x : Array(UInt8), offset : Int = 0)
    false
  end

  def decode(type : Nil.class, x : Array(UInt8), offset : Int = 0)
    nil
  end

  def decode(type : OSC::Type::Inf.class, x : Array(UInt8), offset : Int = 0)
    OSC::Type::Inf
  end

  def decode(type : OSC::Bundle.class, x : Array(UInt8), offset = 0)
    OSC::Bundle.new(x)
  end

  def decode(type : OSC::Message.class, x : Array(UInt8), offset = 0)
    OSC::Message.new(x)
  end

  def decode(type, x, offset)
    raise "not impled"
  end
end
