module OSC::Util
  extend self

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
