require "./spec_helper"

{% skip_file unless flag?(:preview_mt) %}

class SafeCounter < Counter
  include ThreadSafe

  def increment(n : Int)
    safe do
      super
    end
  end
end

describe ThreadSafe, tags:"parallel" do
  it "#safe" do
    n_increments, n_fibers = { 1000000, 2 }
    expect = n_increments*n_fibers
    
    # normal counter should not eq
    counter = Counter.new
    wait Array(Fiber).new(n_fibers) { spawn { counter.increment n_increments } }
    counter.count.should_not eq expect
    
    safe_counter = SafeCounter.new
    wait Array(Fiber).new(n_fibers) { spawn { safe_counter.increment n_increments } }
    safe_counter.count.should eq expect
  end
end
