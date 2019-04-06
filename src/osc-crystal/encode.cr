# Encoding argument value to Array(UInt8)
module OSC::Encode
  extend self

  def encode(x : UInt32)
    [(x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(data : Array(UInt8), x : UInt32)
    data.push((x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8)
  end

  def encode(x : Int32)
    [(x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(data : Array(UInt8), x : Int32)
    data.push((x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8)
  end

  def encode(x : Int64)
    [(x >> 56).to_u8, (x >> 48).to_u8, (x >> 40).to_u8, (x >> 32).to_u8,
     (x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(data : Array(UInt8), x : Int64)
    data.push(
      (x >> 56).to_u8, (x >> 48).to_u8, (x >> 40).to_u8, (x >> 32).to_u8,
      (x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8
    )
  end

  def encode(x : Float32)
    encode(x.unsafe_as(Int32))
  end

  def encode(data : Array(UInt8), x : Float32)
    encode(data, x.unsafe_as(Int32))
  end

  def encode(x : Float64)
    encode(x.unsafe_as(Int64))
  end

  def encode(data : Array(UInt8), x : Float64)
    encode(data, x.unsafe_as(Int64))
  end

  def encode(x : Array(UInt8))
    i = x.size
    OSC::Encode.encode(i) + x
  end

  def encode(data : Array(UInt8), x : Array(UInt8))
    OSC::Encode.encode(data, x.size)
    data.concat(x)
  end

  def encode(x : Time)
    span = x - Time.utc(1900, 1, 1)
    sec = span.total_seconds.to_u32
    frac = ((span.total_milliseconds % 1000) / 200 * 1000).to_u32
    OSC::Encode.encode(sec) + OSC::Encode.encode(frac)
  end

  def encode(data : Array(UInt8), x : Time)
    span = x - Time.utc(1900, 1, 1)
    sec = span.total_seconds.to_u32
    frac = ((span.total_milliseconds % 1000) / 200 * 1000).to_u32
    OSC::Encode.encode(data, sec)
    OSC::Encode.encode(data, frac)
  end

  def encode(x : String)
    OSC::Util.align!(x.bytes << 0_u8)
  end

  def encode(data : Array(UInt8), x : String)
    data.concat(x.bytes)
    data << 0_u8
    OSC::Util.align!(data)
  end

  def encode(x : Char)
    OSC::Encode.encode(0_i32 | x.bytes[0])
  end

  def encode(data : Array(UInt8), x : Char)
    OSC::Encode.encode(data, 0_i32 | x.bytes[0])
  end

  def encode(x : OSC::Type::RGBA)
    [x.r, x.g, x.b, x.a]
  end

  def encode(data : Array(UInt8), x : OSC::Type::RGBA)
    data.push(x.r, x.g, x.b, x.a)
  end

  def encode(x : OSC::Type::Midi)
    x.data
  end

  def encode(data : Array(UInt8), x : OSC::Type::Midi)
    data.concat(x.data)
  end

  def encode(x : OSC::Type::True.class)
    Array(UInt8).new
  end

  def encode(data : Array(UInt8), x : OSC::Type::True.class)
    # nop
  end

  def encode(x : OSC::Type::False.class)
    Array(UInt8).new
  end

  def encode(data : Array(UInt8), x : OSC::Type::False.class)
    # nop
  end

  def encode(x : Nil.class)
    Array(UInt8).new
  end

  def encode(data : Array(UInt8), x : Nil.class)
    # nop
  end

  def encode(x : OSC::Type::Inf.class)
    Array(UInt8).new
  end

  def encode(data : Array(UInt8), x : OSC::Type::Inf.class)
    # nop
  end

  def encode(x)
    raise "no implement"
  end

  def encode(data, x)
    # nop
  end
end
