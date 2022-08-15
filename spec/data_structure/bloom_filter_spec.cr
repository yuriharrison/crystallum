require "./spec_helper.cr"

describe BloomFilter do
  precision = 0.04
  data = Array(String).new(500_000) { rand(Int32).to_s }
  arr = Array(String).new(500_000) { rand(Int32).to_s }
  data = arr.to_set.to_a
  midst = (data.size/2).to_i
  x = data[0...midst]
  y = data[midst..]

  it "#add" do
    bf = BloomFilter.new 2
    bf.add "some key"
    bf << "another key"
  end

  it "#has?" do
    bf = BloomFilter.new 100
    bf.add "some key"
    bf.has?("some key").should eq true
  end

  it "Precision", tags: "precision" do
    bf = BloomFilter.new x.size, precision
    x.each { |i| bf.add i }
    count = 0
    y.each { |i| count += 1 if bf.has?(i) }
    (count/y.size).should be_close precision, 0.01
  end
end