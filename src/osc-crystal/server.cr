require "socket"

module OSC
  class Server
    def initialize(@socket : Socket)
      @methods = Array(Tuple(String, (OSC::Message ->))).new
    end

    def dispatch(address : String, &block : OSC::Message ->)
      @methods << {address, block}
    end

    def run
      spawn do
        loop do
          str, ip = @socket.receive(512)
          if OSC::Util.bundle?(str)
            b = OSC::Bundle.new(str.bytes)
            # TODO: write process for Bundle
          else
            m = OSC::Message.new(str.bytes)
            @methods.each do |address, method|
              if File.match?(m.address, address)
                method.call(m)
              end
            end
          end
        end
      end
    end
  end

  class Client
    def initialize(@socket : Socket)
    end

    def send(m : OSC::Message)
      @socket.send m
    end
  end
end
