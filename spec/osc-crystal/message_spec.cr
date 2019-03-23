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
end
