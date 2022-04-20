require "./spawner"
require "../patterns/publisher"
require "../miscs/with_self"

module Cl::Async
  class Job(I, O) < Spawner
    @function_block : Proc(I, O)?

    include Cl::Patterns::Publisher(O)
    include Cl::Miscs::WithSelf

    def initialize(buffer = 0, **kwargs)
      super **kwargs
      @in = Channel(I).new buffer
    end

    def initialize(**kwargs, &@function_block : I -> O)
      initialize **kwargs
    end

    def self.start(**kwargs, &function_block : I -> O)
      instance = new **kwargs, &function_block
      instance.start
    end

    def publish(item : O)
      @subscribers.each do |block|
        spawn do
          block.call item
        rescue ex
          puts "Unhandled exception on subscriber block."
          puts ex
          caller[0..5].each { |l| puts l}
        end
      end
    end

    def >>(other : Job(O, Object))
      subscribe { |i| other.send i }
      other
    end

    def subscribe_to(other : Job(Object, I))
      other.subscribe { |i| send i }
      self
    end
    
    def <<(other : Job(O, Object))
      subscribe_to other
    end

    def function(&@function_block : I -> O)
    end

    def function(input : I)
      publish @function_block.not_nil!.call input
    end

    def send(message : I)
      @in.send message
    end

    def handler
      function @in.receive
    rescue ex
      puts "Error on Job function call."
      puts ex
    end

    def close
      @in.close
    end
  end
end
