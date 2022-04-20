module Cl::Async
  def every(delay : Time::Span, name : String? = nil, &proc)
    Spawner.start name:name, delay:delay, &proc
  end
  
  def wait(fibers : Enumerable(Object))
    until fibers.all? &.dead?
      Fiber.yield
    end
  end
  
  def wait(*fibers : Fiber)
    wait_all fibers
  end
end