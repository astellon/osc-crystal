require "../spec_helper.cr"

describe OSC::Message do
  it "make message" do
    m = OSC::Message.new("/foo", "i", 0_i32)
    m.tag.should eq "i"
    OSC::Decode.decode(Int32, m.data, m.arg(0)).should eq 0
  end
end