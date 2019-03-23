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

  @@TypeTag = {'i' => Int32,
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

  def tag_to_type(tag : Char)
    @@TypeTag[tag]
  end

  {% for type in {Int32, Float32, String, Array(UInt8), Int64, Time, Float64, Char, OSC::Type::RGBA, OSC::Type::Midi} %}
  def type_to_tag(type : {{type}})
    @@TypeTag.key_for({{type}})
  end
  {% end %}

  {% for type in {OSC::Type::True, OSC::Type::False, Nil, OSC::Type::Inf} %}
  def type_to_tag(type : {{type}}.class)
    @@TypeTag.key_for({{type}})
  end
  {% end %}
end
