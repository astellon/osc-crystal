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
    
    def estimate_size(x : String)
      x.size + 4 - x.size % 4
    end
  
    def estimate_size(x)
      sizeof(typeof(x))
    end
  
    # calculate byte size of data
    def estimate_size(address : String, tag : String, *args)
      # sum = (address.size + (4 - (address.size % 4)))
      #       + (tag.size + 1 + (4 - ((tag.size + 1) % 4)))
      sum = address.size + tag.size - (address.size + tag.size + 1) % 8 + 9
  
      # position of looking argument
      pos = 0
  
      tag.each_char do |t|
        case t
        when 'm', 'r', 'c', 'f', 'i'
          sum += 4
          pos += 1
        when 'h', 't', 'd'
          sum += 8
          pos += 1
        when 's', 'S'
          sum += estimate_size(args[pos])
          pos += 1
        when 'b'
          i = estimate_size(args[pos])
          sum += 4 + i         # add 4 for Int32 count
          sum += 4 - (sum % 4) # add padding
          pos += 1
          # other cases are constants
        end
      end
  
      sum
    end
  end
end
