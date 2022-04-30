require "./benchmark_helper.cr"

def rand_bytes
  Array(UInt8).new 200 { rand(UInt8) }
end

Benchmark.ips do |bm|
  bm.report "murmur3" do
    Hashing::MM3.hash32 rand_bytes
  end

  bm.report "murmur3_old" do
    Hashing::MM3.hash32_old rand_bytes
  end
end