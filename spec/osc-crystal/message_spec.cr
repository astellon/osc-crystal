require "../spec_helper.cr"

describe OSC::Message do
  it "#new" do
    msg
  end

  it "#address" do
    msg.address.should eq "/foo"
  end

  it "#tags" do
    msg.tag.should eq "ifsbhdtscrmTFNI"
  end

  it "#arg" do
    m = OSC::Message.new(
      "/foo",
      0_i32,
      0_f32,
      "String",
      [0_u8, 0_u8, 0_u8, 0_u8],
      0_i64,
      0_f64,
      Time.utc_now, # => cannot compare
      "String",
      '0',
      OSC::Type::RGBA.new(0_u8, 0_u8, 0_u8, 0_u8),
      OSC::Type::Midi.new(0_u8, 0_u8, 0_u8, 0_u8),
      OSC::Type::True,
      OSC::Type::False,
      Nil,
      OSC::Type::Inf
    )

    (0..m.nargs - 1).each do |i|
      if i != 6
        m.arg(i).should eq args[i]
      else
        # ??
      end
    end
  end
end
