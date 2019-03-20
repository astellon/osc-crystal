require "./encode.cr"

module OSC
  extend self

  class Message
    getter data : Array(UInt8)

    def initialize(address : String, tag : String, *args)
      # malloc data Array
      s = OSC::Encode.estimate_size(address, tag, args)
      @data = Array(UInt8).new(s)

      # address
      @data += address.bytes
      OSC::Encode.align!(@data)

      # tag
      @data += ("," + tag).bytes
      OSC::Encode.align!(@data)

      # args
      args.each do |arg|
        @data += OSC::Encode.encode(arg)
      end
    end

    def initialize(@data : Array(UInt8))
    end

    def address
      eoad = @data.index { |x| x == 0 }
      return "" if eoad.nil?
      String.new(@data.to_unsafe, eoad)
    end

    def tag
      pos = 0_i32
      len = @data.size

      while !(@data[pos] === ',')
        pos += 4 # alignment
        return "" if pos > len
      end

      a = pos

      while @data[pos] != 0
        pos += 1
        return "" if pos > len
      end

      String.new(@data.to_unsafe + a + 1, pos - a - 1)
    end

    def nargs
      sum = 0
      tag.each_char do |c|
        case c
        when 'T', 'F', 'N', 'I', '[', ']'
          # no argument
        else
          sum += 1
        end
      end
      sum
    end

    def to_slice
      Slice.new(@data.to_unsafe, @data.size)
    end
  end
end
