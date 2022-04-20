require "spec"
require "../src/crystallum"

include Cl

class Counter
  getter count = 0

  def increment(n : Int)
    n.times { @count += 1 }
  end
end