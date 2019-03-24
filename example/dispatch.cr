require "socket"
require "../src/osc-crystal.cr"

server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

m = OSC::Message.new(
  "/foo",
  1_i32
)

d = OSC.dispatch(server, "/foo") do |m|
  puts m
end

client.send m
client.send m

sleep(1)

client.close
server.close
