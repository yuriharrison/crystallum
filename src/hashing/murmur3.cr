module Cl::Hashing::Murmur
  C1 = 0xcc9e2d51_u32
  C2 = 0x1b873593_u32
  C3 = 0x85ebca6b_u32
  C4 = 0xc2b2ae35_u32
  R1 = 15_u32
  R2 = 13_u32
  M = 5_u32
  N = 0xe6546b64_u32

  def self.hash32(data : Slice(UInt8), seed = 0_u32) : UInt32
    hash = seed
    index = 0
    while index <= data.size - 4
      a, b, c, d = {
        data[index],
        data[index + 1],
        data[index + 2],
        data[index + 3],
      }
      k = a.to_u32 | b.to_u32 << 8 | c.to_u32 << 16 | d.to_u32 << 24
      k &*= C1
      k = (k << R1) | (k >> (32 - R1))
      k &*= C2
      hash ^= k
      hash = (hash << R2) | (hash >> (32 - R2))
      hash = hash &* M &+ N
      
      index += 4
    end

    k = 0_u32
    case data.size - index
    when 3
      k &+= data[index+2] << 16
      k &+= data[index+1] << 8
      k &+= data[index]
    when 2
      k &+= data[index+1] << 8
      k &+= data[index]
    when 1
      k &+= data[index]
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

  def self.hash32(data : Object, seed = 0_u32) : UInt32
    hash32 data.to_slice, seed
  end
end
