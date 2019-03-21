module OSC::Type
  extend self

  class Blob
  end

  class Time
    @time : Array(UInt8)

    def initialize(@time : Array(UInt8))
    end

    def self.now
    end
  end

  class RGBA
    getter r : UInt8
    getter g : UInt8
    getter b : UInt8
    getter a : UInt8

    def initialize(@r, @g, @b, @a)
    end
  end

  class Midi
    getter port : UInt8
    getter status : UInt8
    getter data1 : UInt8
    getter data2 : UInt8

    def initialize(@port, @status, @data1, @data2)
    end
  end

  class True
    def value
      true
    end
  end

  class False
    def value
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
               't' => OSC::Type::Time,
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

  {% for type in {Int32, Float32, String, OSC::Type::Blob, Int64, OSC::Type::Time, Float64, Char, OSC::Type::RGBA, OSC::Type::Midi, OSC::Type::True, OSC::Type::False, Nil, OSC::Type::Inf} %}
  def type_to_tag(type : {{type}}.class)
    @@TypeTag.key_for({{type}})
  end

  def type_to_tag(type : {{type}})
    @@TypeTag.key_for({{type}})
  end
  {% end %}
end
