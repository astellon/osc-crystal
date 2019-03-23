# osc-crystal

Open Sound Control implementations in Crystal.

## Arguments and Type Tags

We support some additional tags that be
shown below:

|OSC Type Tag|Type in Crystal                      |
|:-----------|:--------------                      |
|i           |Int32                                |
|f           |Float32                              |
|s           |String                               |
|b           |OSC::Type::Blob(alias of Array(UIn8))|
|h           |Int64                                |
|t           |OSC::Type::Time (WIP)                |
|S           |String                               |
|c           |Char                                 |
|r           |OSC::Type::RGBA                      |
|m           |OSC::Type::Midi (WIP)                |
|T           |OSC::Type::True                      |
|F           |OSC::Type::False                     |
|N           |Nil                                  |
|I           |OSC::Type::Inf                       |

Tags are inferred form the type of each argument. [See Usage](https://github.com/astellon/osc-crystal#usage).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     oscr:
       github: astellon/osc-crystal
   ```

2. Run `shards install`

## Usage

```crystal
require "osc-crystal"

# make message
m1 = OSC::Message.new("/foo", 0_i32)

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
```

## Contributing

1. Fork it (<https://github.com/astellon/osc-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [astellon](https://github.com/astellon) - creator and maintainer
