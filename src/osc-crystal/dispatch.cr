module OSC
  def dispatch(socket : Socket, address : String, &block : OSC::Message -> _)
    spawn do
      loop do
        str, ip = socket.receive
        if OSC::Util.bundle?(str)
          b = OSC::Bundle.new(str.bytes)
          # TODO: write process for Bundle
        else
          m = OSC::Message.new(str.bytes)
          if File.match?(m.address, address)
            block.call(m)
          end
        end
      end
    end
  end
end
