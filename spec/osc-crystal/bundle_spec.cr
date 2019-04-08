require "../spec_helper.cr"

describe OSC::Bundle do
  it "#new" do
    bun
  end

  it "#time" do
    t = bun.time
    t.should be < Time.utc_now
  end

  it "#nelms" do
    bun.nelms.should eq 2
  end

  it "#elm" do
    parse_rec bun
  end
end
