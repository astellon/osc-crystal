require "./encode.cr"
require "./decode.cr"
require "./util.cr"

module OSC
  extend self

  class Message
    getter data : Array(UInt8)

    def initialize(address : String, tag : String, *args)
      # malloc data Array
      s = OSC::Util.estimate_size(address, tag, args)
      @data = Array(UInt8).new(s)

      # address
      @data += OSC::Encode.encode(address)

      # tag
      @data += OSC::Encode.encode("," + tag)

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

    def to_slice
      Slice.new(@data.to_unsafe, @data.size)
    end
  end
end
