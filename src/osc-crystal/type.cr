module OSC::Type
  extend self

  alias Blob = Array(UInt8)

  class RGBA
    getter r : UInt8
    getter g : UInt8
    getter b : UInt8
    getter a : UInt8

    def initialize(@r, @g, @b, @a)
    end

    def ==(rgba : RGBA)
      @r == rgba.r && @g == rgba.g && @b == rgba.b && @a == rgba.a
    end
  end

  class Midi
    getter data : Array(UInt8)

    def initialize(@data)
    end

    def initialize(port : UInt8, status : UInt8, data1 : UInt8, data2 : UInt8)
      @data = [port, status, data1, data2]
    end

    def ==(m : Midi)
      @data == m.data
    end
  end

  class True
    def self.value
      true
    end
  end

  class False
    def self.value
      false
    end
  end

  class Inf
  end

  @@TagToType = {
    'i' => Int32,
    'f' => Float32,
    's' => String,
    'S' => String,
    'b' => OSC::Type::Blob,
    'h' => Int64,
    't' => Time,
    'd' => Float64,
    'c' => Char,
    'r' => OSC::Type::RGBA,
    'm' => OSC::Type::Midi,
    'T' => OSC::Type::True,
    'F' => OSC::Type::False,
    'N' => Nil,
    'I' => OSC::Type::Inf,
  }

  @@TypeToTag = {
    Int32            => 105_u8,
    Float32          => 102_u8,
    String           => 115_u8,
    OSC::Type::Blob  => 98_u8,
    Int64            => 104_u8,
    Time             => 116_u8,
    Float64          => 100_u8,
    Char             => 99_u8,
    OSC::Type::RGBA  => 114_u8,
    OSC::Type::Midi  => 109_u8,
    OSC::Type::True  => 84_u8,
    OSC::Type::False => 70_u8,
    Nil              => 78_u8,
    OSC::Type::Inf   => 73_u8,
  }

  def tag_to_type(tag : Char)
    @@TagToType[tag]
  end

  {% for type in {Int32, Float32, String, Array(UInt8), Int64, Time, Float64, Char, OSC::Type::RGBA, OSC::Type::Midi} %}
  def type_to_tag(type : {{type}})
    @@TypeToTag[{{type}}]
  end
  {% end %}

  {% for type in {OSC::Type::True, OSC::Type::False, Nil, OSC::Type::Inf} %}
  def type_to_tag(type : {{type}}.class)
    @@TypeToTag[{{type}}]
  end
  {% end %}
end
