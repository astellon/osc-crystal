module OSC
  extend self

  DEFAULT_BUFFER_SIZE = 64

  class Message
    getter data : Array(UInt8)

    def initialize(address : String, *args)
      @data = Array(UInt8).new(DEFAULT_BUFFER_SIZE)

      # address
      OSC::Encode.encode(@data, address)

      # tag
      @data << 44_u8 # ','
      args.each do |arg|
        @data << OSC::Type.type_to_tag(arg)
      end
      @data << 0_u8
      OSC::Util.align! @data

      # args
      args.each do |arg|
        OSC::Encode.encode(@data, arg)
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
      head = OSC::Util.tag_start(@data)
      return "" if head > @data.size
      String.new(@data.to_unsafe + head + 1)
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

    def arg(index : Int)
      return nil if index > nargs

      t = tag
      pos = OSC::Util.args_start(@data)

      argc = tagc = 0
      while tagc < t.size && argc != index
        case t[tagc]
        when 'm', 'r', 'c', 'f', 'i'
          argc += 1
          pos += 4
        when 'h', 't', 'd'
          argc += 1
          pos += 8
        when 's', 'S'
          argc += 1
          pos = OSC::Util.skip_until_null(@data, pos)
          pos = OSC::Util.skip_padding(@data, pos)
        when 'b'
          argc += 1
          pos += OSC::Decode.decode(Int32, @data, pos) + 4
          pos = OSC::Util.skip_padding(@data, pos)
        end
        tagc += 1
      end
      OSC::Decode.decode(OSC::Type.tag_to_type(t[tagc]), @data, pos)
    end

    def to_s(io)
      io << "#<OSC::Message: " << address << "\n"
      t = tag
      argc = 0
      (0..t.size - 1).each do |i|
        io << "  [" << i << "] " << t[i] << ": "

        if !"TFNI".includes?(t[i])
          io << arg(argc)
          argc += 1
        end

        io << "\n"
      end
      io << ">"
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
