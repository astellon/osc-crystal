module OSC
  class Server
    def initialize(@socket : Socket)
      @running = false
      @methods_for_message = Array(Tuple(String, (OSC::Message ->))).new
      @methods_for_bundle = Array((OSC::Bundle ->)).new
    end

    def dispatch(address : String, &block : OSC::Message ->)
      @methods_for_message << {address, block}
    end

    def dispatch_bundle(&block : OSC::Bundle ->)
      @methods_for_message << block
    end

    def run
      @running = true

      spawn do
        while @running
          str, ip = @socket.receive(512)
          if OSC::Util.bundle?(str)
            b = OSC::Bundle.new(str.bytes)
            @methods_for_bundle.each do |method|
              spawn method.call(b)
            end
          else
            m = OSC::Message.new(str.bytes)
            @methods_for_message.each do |address, method|
              if    File.match?(m.address,   address)
                # Matchs a wildcard in the message address against the server filter
                spawn method.call(m)
              elsif File.match?(  address, m.address)
                # Matchs a wildcard in the server filter against the message address
                spawn method.call(m)
              end
            end
          end
        end
      end
    end

    def stop
      @running = @running ^ false
    end
  end

  class Client
    def initialize(@socket : Socket)
    end

    def send(m : OSC::Message | OSC::Bundle)
      @socket.send m
    end
  end
end
