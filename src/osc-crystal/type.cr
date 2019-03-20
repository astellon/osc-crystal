module OSC::Type
  extend self

  class Blob
  end

  class Time
  end

  class RGB
  end

  class Midi
  end

  class True
  end

  class False
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
               'r' => OSC::Type::RGB,
               'm' => OSC::Type::Midi,
               'T' => OSC::Type::True,
               'F' => OSC::Type::False,
               'N' => Nil,
               'I' => OSC::Type::Inf,
  }

  def type(t : Char)
    @@TypeTag[t]
  end
end
