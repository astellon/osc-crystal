module OSC::Util
  extend self

  def estimate_size(x : String)
    x.size + 4 - x.size % 4
  end

  def estimate_size(x)
    sizeof(typeof(x))
  end

  # calculate byte size of data
  def estimate_size(address : String, tag : String, *args)
    # sum = (address.size + (4 - (address.size % 4)))
    #       + (tag.size + 1 + (4 - ((tag.size + 1) % 4)))
    sum = address.size + tag.size - (address.size + tag.size + 1) % 8 + 9

    # position of looking argument
    pos = 0

    tag.each_char do |t|
      case t
      when 'm', 'r', 'c', 'f', 'i'
        sum += 4
        pos += 1
      when 'h', 't', 'd'
        sum += 8
        pos += 1
      when 's', 'S'
        sum += estimate_size(args[pos])
        pos += 1
      when 'b'
        i = estimate_size(args[pos])
        sum += 4 + i         # add 4 for Int32 count
        sum += 4 - (sum % 4) # add padding
        pos += 1
        # other cases are constants
      end
    end
    sum
  end

  # Skip until this find a null(0_u8).
  # This returns the index of past-the-end,
  # if given data does'nt contain null.
  def skip_until_null(data : Array(UInt8), offset = 0)
    while offset < data.size && data[offset] != 0
      offset += 1
    end
    offset
  end

  # Skip null(0_u8).
  def skip_null(data : Array(UInt8), offset = 0)
    while offset < data.size && data[offset] == 0
      offset += 1
    end
    offset
  end

  # Skip paddig (skip 0-lim additional zero)
  def skip_padding(data : Array(UInt8), offset = 0)
    while offset % 4 != 0 && offset < data.size && data[offset] == 0
      offset += 1
    end
    offset
  end

  def tag_start(data : Array(UInt8))
    pos = 0
    until pos < data.size && data[pos] === ','
      pos += 4
    end
    pos
  end

  def args_start(data : Array(UInt8))
    skip_padding(data, skip_until_null(data, tag_start(data)))
  end
end
