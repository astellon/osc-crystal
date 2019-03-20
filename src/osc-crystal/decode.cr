module OSC::Decode
  extend self

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

  def decode(type, x, offset)
    raise "not impled"
  end
end
