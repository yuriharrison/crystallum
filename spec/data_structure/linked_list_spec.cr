require "./spec_helper"

describe LinkedList do
  n = 10

  it Iterator do
    Queue(Int32).new.should be_a Iterator(Int32)
  end

  it "Iterator#accumulate" do
    queue = Queue(Int32).build do
      n.times { |i| push i }
    end
    accumulator, count = {0, 0}
    queue.accumulate.each do |accumulate|
      accumulator += count
      accumulate.should eq accumulator
      count += 1
    end
  end

  it FIFO do
    queue = Queue(Int32).build do
      n.times { |i| push i }
    end
    n.times do |i|
      queue.peak.should eq i
      queue.next.should eq i
    end
  end

  it FILO do
    stack = Stack(typeof(n)).build do
      n.times { |i| push i }
    end
    (n...0).each do |i|
      stack.peak.should eq i
      stack.next.should eq i
    end
  end
end
