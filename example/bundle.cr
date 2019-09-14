require "socket"
require "../src/osc-crystal.cr"

# set up UDP server/client
server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

# initialize bundle
b = OSC::Bundle.new(Time.utc, OSC::Message.new("/foo", 1), OSC::Message.new("/foo", 2))

# send bundle
client.send b

# receive bunle
message, client_addr = server.receive

# decode and show bundle (or message)
if OSC::Util.message?(message)
  puts OSC::Message.new(message.bytes)
else
  puts OSC::Bundle.new(message.bytes)
end

client.close
server.close
