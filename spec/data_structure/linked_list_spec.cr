require "./spec_helper"

describe LinkedList do
  it FIFO do
    n = 10
    queue = Queue(typeof(n)).build do
      n.times { |i| push i }
    end
    n.times do |i|
      queue.peak.should eq i
      queue.next.should eq i
    end
  end

  it FILO do
    n = 10
    stack = Stack(typeof(n)).build do
      n.times { |i| push i }
    end
    (n...0).each do |i|
      stack.peak.should eq i
      stack.next.should eq i
    end
  end
end
