module OSC::Util
  extend self

  # Insert 0-3 null charactors to align.
  def align!(x : Array(UInt8))
    pad = 4 - x.size & 3
    while pad > 0
      x.push(0_u8)
      pad -= 1
    end
    x
  end

  # Calculate next aligned boundaries
  def align(x : Int)
    (x + 3) & ~3
  end

  # Skip until this find a null charactors.
  # This returns the index of past-the-end,
  # if given data does'nt contain null.
  def skip_until_null(data : Array(UInt8), offset = 0)
    while offset < data.size && data[offset] != 0
      offset += 1
    end
    offset
  end

  # Skip null charactors.
  def skip_null(data : Array(UInt8), offset = 0)
    while offset < data.size && data[offset] == 0
      offset += 1
    end
    offset
  end

  # Skip paddig (proceed the position to next head of alignment).
  def skip_padding(data : Array(UInt8), offset = 0)
    while offset % 4 != 0 && offset < data.size && data[offset] == 0
      offset += 1
    end
    offset
  end

  # Serch index of head of tag including ','
  def tag_start(data : Array(UInt8))
    pos = 0
    until pos < data.size && data[pos] === ','
      pos += 4
    end
    pos
  end

  # Serch index of head of arguments
  def args_start(data : Array(UInt8))
    skip_padding(data, skip_until_null(data, tag_start(data)) + 1)
  end

  # Check if data is bundle.
  def bundle?(data : Array(UInt8), pos = 0)
    data[pos]
    '#' === data[pos]
  end

  # Check if data is bundle.
  def bundle?(data : String)
    data.starts_with?("#")
  end

  # Check if data is Message.
  def message?(data : Array(UInt8), pos = 0)
    !OSC::Util.bundle?(data, pos)
  end

  # Check if data is Message.
  def message?(data : String)
    !OSC::Util.bundle?(data)
  end
end
