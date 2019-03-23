require "benchmark"
require "socket"
require "./src/osc-crystal.cr"

client = UDPSocket.new
client.connect "localhost", 8000

m = OSC::Message.new(
  "/foo",
  0_i32,
  0_f32,
  "hoge",
  [0_u8, 0_u8, 0_u8, 0_u8],
  # t,
  1_i64,
  2_f32,
  '0',
  OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
  # m,
  OSC::Type::True,
  OSC::Type::False,
  Nil,
  OSC::Type::Inf
)

puts m.data

client.send m

client.close