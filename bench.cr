require "benchmark"
require "./src/osc-crystal.cr"

def const
  i = 0
  (1..1024).each do |x|
    i += x ^ 2
  end
  i
end

def light_init
  m = OSC::Message.new("/")
end

def heavy_init
  m = OSC::Message.new(
    "/astellon/test/mesagge/address",
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
end

Benchmark.ips do |x|
  x.report("simple loop") { const() }
  x.report("light Message") { light_init() }
  x.report("heavy Message") { heavy_init() }
end

# results

# v0.1.0
# simple loop   689.11M (  1.45ns) (± 3.76%)     0 B/op          fastest
# light Message   4.05M (246.76ns) (± 3.97%)   291 B/op   170.05× slower
# heavy Message 243.75k (   4.1µs) (± 7.19%)  5424 B/op  2827.06× slower

# master commit a6e76c822e99823ea43009a63aa47633f05c085c
# simple loop    598.5M (  1.67ns) (± 0.57%)    0 B/op         fastest
# light Message   7.42M (134.76ns) (± 1.70%)  193 B/op   80.66× slower
# heavy Message   1.49M (672.31ns) (± 4.57%)  640 B/op  402.38× slower
