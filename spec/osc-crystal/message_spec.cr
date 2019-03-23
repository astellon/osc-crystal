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
    m = msg
    (0..m.nargs - 1).each do |i|
      m.arg(i).should eq args[i]
    end
  end
end
