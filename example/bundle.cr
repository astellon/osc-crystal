require "socket"
require "../src/osc-crystal.cr"

server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

b = OSC::Bundle.new(Time.utc_now, OSC::Message.new("/foo", 1), OSC::Message.new("/foo", 2))

client.send b

message, client_addr = server.receive

client.close
server.close

if OSC::Util.message?(message)
  puts OSC::Message.new(message.bytes)
else
  puts OSC::Bundle.new(message.bytes)
end
