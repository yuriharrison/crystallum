module Cl::Async
  module ThreadSafe
    @mutext = Mutex.new

    def safe
      @mutext.lock
      yield
    ensure
      @mutext.unlock
    end
  end
end
