require "./benchmark_helper"

include Cl::DS
include Cl::Debug

SIZE = 1_000_000
DATA = Array(String).new(SIZE) { rand(UInt64).to_s }

def create_set
  Set(String).new(initial_capacity: DATA.size).tap do |set|
    DATA.each { |i| set.add i }
  end
end

def create_bloom_filter
  BloomFilter.new(DATA.size).tap do |filter|
    DATA.each { |i| filter.add i }
  end
end

report_memory Set do
  create_set
end

report_memory BloomFilter do
  create_bloom_filter  
end

Benchmark.ips do |bm|
  set = create_set
  bloom_filter = create_bloom_filter

  bm.report Set.name do
    index = rand(DATA.size)
    set.add? DATA[index]
  end
  
  bm.report BloomFilter.name do
    index = rand(DATA.size)
    bloom_filter.has? DATA[index]
  end
end
