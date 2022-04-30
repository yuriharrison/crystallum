require "bit_array"

require "../hashing/murmur3"

module Cl::DS
  class BloomFilter
    include Cl::Hashing

    @hash_count = uninitialized Int32
  
    def initialize(n, error_rate=0.001)
      raise Exception.new "error_rate must be between 0 and 1" \
        unless 0 < error_rate < 1
  
      m = get_size n, error_rate
      @store = BitArray.new m
      @hash_count = get_hash_count m, n
      @seeds = Array(UInt32).new @hash_count { rand(UInt32) }
    end
  
    private def get_size(n : Int, p : Float) : Int
      (-(n*Math.log(p)/Math.log(2)**2)).to_i
    end
  
    private def get_hash_count(m : Int, n : Int) : Int
      ((m/n)*Math.log(2)).to_i
    end
  
    def <<(key : String)
      add key
    end
  
    def add(key : String)
      @hash_count.times do |i|
        index = Murmur.hash32(key, @seeds[i]) % @store.size
        @store[index] = true
      end
    end
  
    def has?(key : String) : Bool
      @hash_count.times do |i|
        index = Murmur.hash32(key, @seeds[i]) % @store.size
        return false unless @store[index]
      end
      true
    end
  end
end