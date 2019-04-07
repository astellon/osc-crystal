require "socket"
require "../src/osc-crystal.cr"

client = UDPSocket.new
client.connect "localhost", 8000

client.send OSC::Message.new("/mouse/button", "down")
client.send OSC::Message.new("/mouse/position", 10, 80)

client.close
