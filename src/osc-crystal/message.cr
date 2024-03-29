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
      tag.size
    end

    def arg(index : Int)
      raise IndexError.new if index > nargs

      t = tag  # pre-call

      raise IndexError.new if t.size == 0

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
        when 's'
          argc += 1
          pos = OSC::Util.skip_until_null(@data, pos)
          pos = OSC::Util.skip_padding(@data, pos)
        when 'b'
          argc += 1
          pos += OSC::Decode.decode(Int32, @data, pos) + 4
          pos = OSC::Util.skip_padding(@data, pos)
        when 'T', 'F', 'N', 'I'
          argc += 1
        else
          # unknown type tag
          raise OSC::UnsupportedTypeTag.new
        end
        tagc += 1
      end

      OSC::Decode.decode(OSC::Type.tag_to_type(t[tagc]), @data, pos)
    end

    def arg(type : T.class, index : Int) forall T
      case a = arg(index)
      when T
        return a.as(T)
      else
        raise "Not Satisfy the Type of the Argument"
      end
    end

    def args : Array(Type::Types)
      (0...nargs).map do |i|
        case ret = arg(i)
          # These types can be returned as-is:
          when Array(UInt8), Char, Float32, Float64, Int32, Int64, Type::Inf, Type::Midi, Type::RGBA, String, Time, Nil
            ret
          # These need(?) mapping from the class types.
          when Type::False.class
            Type::False.new
          when Type::Inf.class
            Type::Inf.new
          when Type::True.class
            Type::True.new
        end
      end

    end

    def [](index : Int)
      arg(index)
    end

    def to_s(io)
      io << "#<OSC::Message: " << address << tag << ">"
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
