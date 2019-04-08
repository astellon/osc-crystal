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

def bun
  b1 = OSC::Bundle.new(Time.utc_now, OSC::Message.new("/foo", *args))
  OSC::Bundle.new(Time.utc_now, OSC::Message.new("/foo", *args), b1)
end

def parse_rec(bundle : OSC::Bundle)
  (0..bundle.nelms - 1).each do |i|
    elm = bundle.elm(i)
    raise "got nil" if elm.nil?
    case elm
    when OSC::Bundle
      parse_rec(elm)
    when OSC::Message
      elm.address.should eq "/foo"
    end
  end
end
