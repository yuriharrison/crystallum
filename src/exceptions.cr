module Cl
  class EmptyException < Exception
    def initialize(message : String)
      super
    end
  end
end
