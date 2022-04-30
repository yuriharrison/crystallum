require "./benchmark_helper.cr"

def rand_bytes
  Array(UInt8).new 200 { rand(UInt8) }
end

Benchmark.ips do |bm|
  bm.report "murmur3" do
    Hashing::Murmur.hash32 rand_bytes
  end
end