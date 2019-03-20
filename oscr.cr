require "./encode.cr"

module OSC
  extend self

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

  class Message
    getter data : Array(UInt8)

    def initialize(address : String, tag : String, *args)
      # malloc data Array
      s = OSC.estimate_size(address, tag, args)
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
