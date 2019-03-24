module OSC
  def dispatch(socket : Socket, address : String, &block : OSC::Message -> _)
    spawn do
      loop do
        str, ip = socket.receive
        if OSC::Util.bundle?(str)
          # for bundle
        else
          m = OSC::Message.new(str.bytes)
          if OSC.match(m.address, address)
            block.call(m)
          end
        end
      end
    end
  end

  def match(pattern : String, address : String)
    true
  end
end
