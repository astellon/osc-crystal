require "benchmark"
require "socket"
require "./src/osc-crystal.cr"

server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

m1 = OSC::Message.new("/foo", 0_i32)
puts m1.tag

client.send m1

message, client_addr = server.receive
m2 = OSC::Message.new(message.bytes)
puts m2.address

client.close
server.close

m = OSC::Message.new(
  "/foo",
  1_i32,
  2_f32,
  "String",
  [0_u8, 0_u8, 0_u8, 0_u8],
  # t,
  3_i64,
  4_f32,
  '0',
  OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
  # m,
  OSC::Type::True,
  OSC::Type::False,
  Nil,
  OSC::Type::Inf
)

m1 = OSC::Message.new("/", [0_u8, 0_u8, 0_u8, 0_u8])

(0..m.nargs-1).each do |i|
  puts m.arg(i)
end
