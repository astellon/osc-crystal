# Encoding argument value to Array(UInt8)
module OSC::Encode
  extend self

  def encode(x : UInt32)
    [(x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(x : Int32)
    [(x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(x : Int64)
    [(x >> 56).to_u8, (x >> 48).to_u8, (x >> 40).to_u8, (x >> 32).to_u8,
     (x >> 24).to_u8, (x >> 16).to_u8, (x >> 8).to_u8, x.to_u8]
  end

  def encode(x : Float32)
    encode(x.unsafe_as(Int32))
  end

  def encode(x : Float64)
    encode(x.unsafe_as(Int64))
  end

  def encode(x : Array(UInt8))
    i = x.size
    OSC::Encode.encode(i) + x
  end

  def encode(x : Time)
    span = x - Time.utc(1900, 1, 1)
    sec = span.total_seconds.to_u32
    frac = ((span.total_milliseconds % 1000) / 200 * 1000).to_u32
    OSC::Encode.encode(sec) + OSC::Encode.encode(frac)
  end

  def encode(x : String)
    OSC::Util.align!(x.bytes << 0_u8)
  end

  def encode(x : Char)
    OSC::Encode.encode(0_i32 | x.bytes[0])
  end

  def encode(x : OSC::Type::RGBA)
    [x.r, x.g, x.b, x.a]
  end

  def encode(x : OSC::Type::Midi)
    x.data
  end

  def encode(x : OSC::Type::True.class)
    Array(UInt8).new
  end

  def encode(x : OSC::Type::False.class)
    Array(UInt8).new
  end

  def encode(x : Nil.class)
    Array(UInt8).new
  end

  def encode(x : OSC::Type::Inf.class)
    Array(UInt8).new
  end

  def encode(x)
    raise "no implement"
  end
end
