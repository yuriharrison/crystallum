module Cl::Async
  class RunningException < Exception
  end
  
  class Spawner
    @fiber : Fiber?
    @stop_ch = Channel(Nil).new
    @proc : Proc(Nil)?
  
    def initialize(@name : String? = nil, @delay : Time::Span = Time::Span::ZERO)
    end
  
    def initialize(*, @name : String? = nil, @delay : Time::Span = Time::Span::ZERO, &@proc : -> )
    end
  
    def handler
      @proc.as(Proc(Nil)).call
    end
  
    def self.start(**kwargs, &proc : -> )
      instance = new **kwargs, &proc
      instance.start
    end
  
    def self.start(**kwargs)
      instance = new **kwargs
      instance.start
    end
  
    protected def loop_delay
      loop {
        sleep @delay
        yield
      }
    end
  
    def stop
      return if @fiber.nil? || dead?
      @stop_ch.send nil
    end
  
    def dead?
      return false unless @fiber.as?(Fiber)
      @fiber.as(Fiber).dead?
    end
  
    def start
      unless @fiber.nil? || @fiber.as(Fiber).dead?
        raise RunningException.new "Fiber already running."
      end
  
      @fiber = spawn(name:@name) {
        loop_delay do
          select
          when @stop_ch.receive
            break
          else
            handler
          end
        end
      }
      self
    end
  end
end
