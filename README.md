<p align="center"><img src="/logo/logotype-horizontal.png"></p>

# osc-crystal

Open Sound Control implementation in Crystal.

This implementation is based on the [The Open Sound Control 1.0 Specification](http://opensoundcontrol.org/spec-1_0) and including some extensions (extra type-tag and dispatching).

## Features

- encode/decode OSC message
- support extra type-tags associated with the tyeps in Crystal
- on receiving message, pattern matching and calling back concurrently

## Arguments and Type Tags

This supports some additional tags that be
shown below:

|OSC Type Tag|Type in Crystal                      |
|:-----------|:--------------                      |
|i           |Int32                                |
|f           |Float32                              |
|s           |String                               |
|b           |OSC::Type::Blob(alias of Array(UIn8))|
|h           |Int64                                |
|d           |Float64                              |
|t           |Time                                 |
|c           |Char                                 |
|r           |OSC::Type::RGBA                      |
|m           |OSC::Type::Midi                      |
|T           |OSC::Type::True                      |
|F           |OSC::Type::False                     |
|N           |Nil                                  |
|I           |OSC::Type::Inf                       |

Tags are inferred form the type of each argument. [See Usage](https://github.com/astellon/osc-crystal#usage).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     osc-crystal:
       github: astellon/osc-crystal
   ```

2. Run `shards install`

## Usage

Get start, send OSC Message via UDP soket in localhost.

```crystal
require "osc-crystal"

# make message
m1 = OSC::Message.new("/addr", 0_i32)

# set up UDP server/client
server = UDPSocket.new
server.bind "localhost", 8000

client = UDPSocket.new
client.connect "localhost", 8000

# send message
client.send m1

# receive massage
message, client_addr = server.receive

# decode from bytes
m2 = OSC::Message.new(message.bytes)

# get argumanent
m2.arg(0) # => 0
```

Tags are inferred form the type of each argument like:

```crystal
m = OSC::Message.new(
      "/foo",
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
      OSC::Type::Inf
    )

m.tag  # => ifsbhdtscrmTFNI
```

The best way to handle the messages is to use `OSC::Server` and `OSC::Client`. You can specify the address and the process that will be involked when the given socket receives OSC messages. Example:

```crystal
require "socket"
require "osc-crystal"

# set up UDP server/client and wrap sockets with OSC classes
server = UDPSocket.new
server.bind "localhost", 8000
osc_server = OSC::Server.new(server)

client = UDPSocket.new
client.connect "localhost", 8000
osc_client = OSC::Client.new(client)

# initialize `OSC::Message`s
m1 = OSC::Message.new(
  "/*/*",
  1_i32
)

m2 = OSC::Message.new(
  "/*/hoge",
  1_i32
)

# add methods for specific address
osc_server.dispatch("/foo/hoge") do |m|
  puts "dispatched: /foo/hoge for #{m.address}"
end

osc_server.dispatch("/foo/fuga") do |m|
  puts "dispatched: /foo/fuga for #{m.address}"
end

# run server concurrently (return immediately)
osc_server.run

# send messages
osc_client.send m1
# => dispatched: /foo/hoge for /*/*
#    dispatched: /foo/fuga for /*/*

osc_client.send m2
# => dispatched: /foo/hoge for /*/hoge

# Sleep a second
sleep(1)

client.close
server.close
```

## Contributing

1. Fork it (<https://github.com/astellon/osc-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [astellon](https://github.com/astellon) - creator and maintainer
- [Tobaloidee](https://github.com/Tobaloidee) - logo
