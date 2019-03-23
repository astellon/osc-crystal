require "spec"
require "../src/osc-crystal.cr"

def msg
  OSC::Message.new(
    "/foo",
    0_i32,
    0_f32,
    "String",
    [0_u8, 0_u8, 0_u8, 0_u8],
    # t,
    0_i64,
    0_f32,
    '0',
    OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
    # m,
    OSC::Type::True,
    OSC::Type::False,
    Nil,
    OSC::Type::Inf
  )
end
