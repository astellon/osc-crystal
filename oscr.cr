
module OSC
  extend self

  {% for type in {Int32, Float32} %}
  def encode(x : {{type}})
    x.unsafe_as(StaticArray(UInt8, 4)).reverse!.to_a
  end
  {% end %}

  {% for type in {Int64, Float64} %}
  def encode(x : {{type}})
    x.unsafe_as(StaticArray(UInt8, 8)).reverse!.to_a
  end
  {% end %}

  def align(data)
    padd = 4 - (data.size) % 4
    (1..padd).each do
      data.push(0_u8)
    end
  end

  class Message
    getter data : Array(UInt8)

    def initialize(address : String, tag : String, *args)
      @data = address.bytes
      OSC.align(@data)
      @data += ("," + tag).bytes
      OSC.align(@data)
      args.each do |arg|
        @data += OSC.encode(arg)
      end
    end

    def initialize(@data : Array(UInt8))
    end

    def address
      eoad = @data.index { |x| x == 0 }
      return nil if eoad.nil?
      String.new(@data.to_unsafe, eoad)
    end

    def tag
      eoad = @data.index { |x| x == 0 }
      return nil if eoad.nil?
      skip = @data.index(offset: eoad) { |x| x != 0 }
      return nil if skip.nil?
      last = @data.index(offset: skip) { |x| x == 0 }
      return nil if last.nil?
      String.new(@data.to_unsafe + skip + 1, last - skip - 1)
    end

    def to_slice
      Slice.new(@data.to_unsafe, @data.size)
    end
  end
end
