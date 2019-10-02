module OSC
  extend self

  class UnsupportedTypeTag < Exception
    def initialize(message : String? = "Unsupported Type Tag")
      super(message)
    end
  end
end