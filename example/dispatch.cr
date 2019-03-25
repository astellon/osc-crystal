require "socket"
require "../src/osc-crystal.cr"

# set up UDP server/client and wrap sockets with OSC classes
server = UDPSocket.new
server.bind "localhost", 8000
osc_server = OSC::Server.new(server)

client = UDPSocket.new
client.connect "localhost", 8000
osc_client = OSC::Client.new(client)

# initialize `OSC::Message`s
m1 = OSC::Message.new(
  "/*/*",
  1_i32
)

m2 = OSC::Message.new(
  "/*/hoge",
  1_i32
)

# add methods for specific address
osc_server.dispatch("/foo/hoge") do |m|
  puts "dispatched: /foo/hoge for #{m.address}"
end

osc_server.dispatch("/foo/fuga") do |m|
  puts "dispatched: /foo/fuga for #{m.address}"
end

# run server concurrently (return immediately)
osc_server.run

# send messages
osc_client.send m1
osc_client.send m2

# Sleep a second
sleep(1)

client.close
server.close
