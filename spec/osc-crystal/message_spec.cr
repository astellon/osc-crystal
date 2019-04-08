require "../spec_helper.cr"

describe OSC::Message do
  it "#new" do
    msg
  end

  it "#address" do
    msg.address.should eq "/foo"
  end

  it "#tags" do
    msg.tag.should eq "ifsbhdtcrmTFNI"
  end

  it "#arg(index : Int)" do
    m = msg

    (0..m.nargs - 1).each do |i|
      if i != 6
        m[i].should eq args[i]
      else
        # ??
      end
    end

    m = OSC::Message.new("/foo")
    m = OSC::Message.new(m.data)
    m.tag.should eq ""
    m.arg(0).should be_nil
  end

  it "#arg(type : T.class, index : Int) forall T" do
    m = OSC::Message.new("/foo", 1_i32, 2_i64)
    m.arg(Int32, 0).should eq 1_i32
    m.arg(Int64, 1).should eq 2_i64
  end
end
