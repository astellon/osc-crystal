require "socket"
require "../src/osc-crystal.cr"

server = UDPSocket.new
server.bind "localhost", 8000
osc_server = OSC::Server.new(server)

client = UDPSocket.new
client.connect "localhost", 8000
osc_client = OSC::Client.new(client)

m = OSC::Message.new(
  "/*",
  1_i32
)

osc_server.dispatch("/foo") do |m|
  puts "dis 1"
end

osc_server.dispatch("/foo") do |m|
  puts "dis 2"
end

osc_server.run

osc_client.send m
osc_client.send m

sleep(1)

client.close
server.close
