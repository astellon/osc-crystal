require "benchmark"
require "socket"
require "./src/osc-crystal.cr"

server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

m = OSC::Message.new(
  "/foo",
  0_i32,
  0_f32,
  "String",
  [0_u8, 0_u8, 0_u8, 0_u8],
  0_i64,
  0_f64,
  # Time.utc_now,
  "String",
  '0',
  OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
  OSC::Type::Midi.new(0_u8, 0_u8, 0_u8, 0_u8),
  OSC::Type::True,
  OSC::Type::False,
  Nil,
  OSC::Type::Inf
)

client.send m

message, client_addr = server.receive
m_ret = OSC::Message.new(message.bytes)

client.close
server.close

(0..m_ret.nargs-1).each do |i|
  puts m_ret.arg(i)
end
