module Cl::DS
  class Node(I)
    property "next"
    getter "value"

    def initialize(@value : I, @next : Node(I)? = nil)
    end
  end
end
