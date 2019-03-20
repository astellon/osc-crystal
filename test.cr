require "socket"
require "./oscr.cr"

server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

m1 = OSC::Message.new("/foo", "ifd", 1, 1.2_f32)

client.send m1

message, client_addr = server.receive
m2 = OSC::Message.new(message.bytes)
puts m2.arg(0)

client.close
server.close
