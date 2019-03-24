require "spec"
require "../src/osc-crystal.cr"

def args
  {
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
    OSC::Type::Inf,
  }
end

def msg
  OSC::Message.new("/foo", *args)
end
