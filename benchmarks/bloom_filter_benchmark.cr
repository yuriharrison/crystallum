require "./benchmark_helper"

include Cl::DS

SIZE = 1_000_000
DATA = Array(String).new(SIZE) { rand(UInt64).to_s }

m1 = Benchmark.memory do
  filter = BloomFilter.new DATA.size
  DATA.each { |i| filter << i }
end

puts "m1\t#{m1.humanize(base: 1024)}"
