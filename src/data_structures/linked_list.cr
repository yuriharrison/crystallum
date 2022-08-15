require "mutex"

require "./node"
require "../exceptions"


module Cl::DS
  abstract class LinkedList(I)
    include Iterator(I)

    @head : Node(I)?

    def self.build(&block)
      ll = new
      with ll yield
      ll
    end

    abstract def push(item : I)

    def each
      head = @head
      until head.nil?
        yield head.value
        head = current.next
      end
    end

    def peak : I?
      @head.nil? ? nil : @head.not_nil!.value
    end
    
    def next?() I?
      return nil if empty?
      self.next
    end
    
    def next : I | Iterator::Stop
      return stop if empty?
      current = @head.not_nil!
      @head = current.next
      current.value
    end

    def empty? : Bool
      @head.nil?
    end
  end

  class FIFO(I) < LinkedList(I)
    @tail : Node(I)?

    def push(item : I)
      new_node = Node(I).new item
      @head = new_node if @head.nil?
      @tail.not_nil!.next = new_node unless @tail.nil?
      @tail = new_node
    end
  end

  alias Queue = FIFO

  class FILO(I) < LinkedList(I)
    def push(item : I)
      @head = Node(I).new item, next:@head
    end
  end

  alias Stack = FILO
end
