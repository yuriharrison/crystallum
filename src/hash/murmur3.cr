module MM3
	C1 = 0xcc9e2d51_u32
	C2 = 0x1b873593_u32
	C3 = 0x85ebca6b_u32
	C4 = 0xc2b2ae35_u32
	R1 = 15_u32
	R2 = 13_u32
	M = 5_u32
	N = 0xe6546b64_u32
  Steps32 = { 0, 8, 16, 24 }

  def batch(data : Array(UInt8), size = 4)
    (0...data.size).step 4 do |i|
      break unless data.size > (i+3)
      yield data[i], data[i+1], data[i+2], data[i+3]
    end
  end

  def hash32(data : Array(UInt8), seed = 0_u32) : UInt32
    hash = seed
    batch data do |a, b, c, d|
      k = a.to_u32 | b.to_u32 << 8 | c.to_u32 << 16 | d.to_u32 << 24
      puts k, C1
      k &*= C1
      k = (k << R1) | (k >> (32 - R1))
      k &*= C2
      hash ^= k
      hash = (hash << R2) | (hash >> (32 - R2))
      hash = hash &* M &+ N
    end

    remains_size = data.size % 4
    remains = data[data.size-remains_size-1..]
    k = 0_u32
    Steps32.reverse.to_a[0...remains_size].each_with_index do |step, i|
      k += remains[2-i] << step
    end
    k &*= C1
    k = (k << R1) | (k >> (32 - R1))
    k &*= C2
    hash ^= k

    hash ^= data.size.to_u32
    hash ^= hash >> 16
    hash &*= C3
    hash ^= hash >> 13
    hash &*= C4
    hash ^= hash >> 16
    hash
  end

end

include MM3
hash32 Array(UInt8).new 14, UInt8::MAX
