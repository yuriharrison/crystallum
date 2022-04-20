module Cl::Patterns::Publisher(O)
  @subscribers = Set(Proc(O, Nil)).new

  protected def publish(value : O)
    @subscribers.each &.call value
  end

  def subscribe(&block : O ->)
    @subscribers << block
    -> { unsubscribe block }
  end

  def unsubscribe(block : Proc(O, Void))
    @subscribers.delete block
  end
end
