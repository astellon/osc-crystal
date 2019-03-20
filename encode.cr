module OSC
  record RGB, r : UInt8, g : UInt8, b : UInt8, a : UInt8

  module Encode
    extend self

    # Insert null and alignment
    def align!(x : Array(UInt8))
      pad = 4 - (x.size) % 4
      while pad > 0
        x.push(0_u8)
        pad -= 1
      end
      x
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

    def encode(x : String)
      align!(x.bytes)
    end

    def encode(x : Char)
      x.to_u8
    end

    def encode(x : RGB)
      [x.r, x.g, x.b, x.a]
    end
  end
end
