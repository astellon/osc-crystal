module OSC
  alias BudleElement = OSC::Bundle | OSC::Message
  
  class Bundle
    getter data : Array(UInt8)

    def initialize(time : Time, *elms)
      # "#bundle" and padding
      @data = "#bundle\0".bytes

      # timetag
      OSC::Encode.encode(@data, time)

      # elms (expected to be aligned)
      elms.each do |elm|
        OSC::Encode.encode(@data, elm.data.size)
        @data += elm.data
      end
    end

    def initialize(@data : Array(UInt8))
    end

    def time
      OSC::Decode.decode(Time, @data, 8)
    end

    def nelms
      elmc = 0
      pos = 16 # skip "#bundle\0" and timetag
      len = @data.size

      while pos < len
        i = OSC::Decode.decode(Int32, @data, pos)
        pos += 4 + i
        elmc += 1
      end

      elmc
    end

    def elm?(index : Int)
      elmc = 0
      pos = 16 # skip "#bundle\0" and timetag
      len = @data.size

      while elmc < index
        i = OSC::Decode.decode(Int32, @data, pos)
        pos += 4 + i
        elmc += 1
        return nil if pos > len
      end

      size = OSC::Decode.decode(Int32, @data, pos)

      if OSC::Util.bundle?(@data, pos + 4)
        return OSC::Bundle.new(@data[pos + 4, size])
      else
        return OSC::Message.new(@data[pos + 4, size])
      end
    end

    def elm(index : Int)
      ret = elm?(index)
      raise "No Element at the give index" if ret.nil?
      ret
    end

    def to_s(io)
      io << "#<OSC::Bundle: " << "\n"
      elmc = 0
      (0..nelms - 1).each do |i|
        io << "[" << i << "] " << "\n" << elm(i) << "\n"
      end
      io << ">\n"
    end

    def to_s
      io = IO::Memory.new
      to_s(io)
      to.to_s
    end

    def to_slice
      Slice.new(@data.to_unsafe, @data.size)
    end
  end
end
