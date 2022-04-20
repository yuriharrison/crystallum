module Cl::Miscs
  module WithSelf
    def self.with_new(*args, **kwargs)
      instance = new *args, **kwargs
      with instance yield
      instance
    end
  
    def with_self(*args, **kwargs)
      with self yield
      self
    end
  end
end
