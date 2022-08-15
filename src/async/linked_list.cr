require "./threading"
require "../data_structures/linked_list"

module Cl::Async
  module SafeLinkedList(I)
    include ThreadSafe
    
    abstract def empty? : Bool
    
    def push(item : I)
      safe do
        super
      end
    end

    def next : I | Iterator::Stop
      safe do
        super
      end
    end

    def send(item : I)
      push item
    end

    def receive : I
      while empty?
        Fiber.yield
      end
      self.next
    end
  end

  class Cl::DS::FIFO(I)
    include Cl::Async::SafeLinkedList(I)
  end

  class Cl::DS::FILO(I)
    include Cl::Async::SafeLinkedList(I)
  end
end