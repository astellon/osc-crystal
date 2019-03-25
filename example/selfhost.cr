require "socket"
require "../src/osc-crystal.cr"

# set up UDP server/client
server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

# make message
m = OSC::Message.new(
  "/foo",
  0_i32,
  0_f32,
  "String",
  [0_u8, 0_u8, 0_u8, 0_u8],
  0_i64,
  0_f64,
  Time.utc_now,
  "String",
  '0',
  OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
  OSC::Type::Midi.new(0_u8, 0_u8, 0_u8, 0_u8),
  OSC::Type::True,
  OSC::Type::False,
  Nil,
  OSC::Type::Inf
)

# send message
client.send m

# receive massage
message, client_addr = server.receive

# decode and show message
if OSC::Util.message?(message)
  puts OSC::Message.new(message.bytes)
end

client.close
server.close
