module Cl::Patterns
  abstract class Repository
    alias Key = Symbol | String
    Register = Hash(Tuple(Repository.class, Key), Repository.class).new
    
    def self.new(*a, **kw)
    end

    def self.repository_context : Repository.class
      Repository
    end
    
    macro inherited
      {% unless @type.abstract? %}
      def self.new
        instance = {{@type}}.allocate
        instance.initialize
        instance
      end

      def self.new(*a, **kw)
        instance = {{@type}}.allocate
        instance.initialize *a, **kw
        instance
      end
      
      def self.registrate(symbol)
        key = { {{ @type.superclass }}, symbol }
        Register[key] = {{@type}}
      end
      
      {% end %}
    end
    
    def self.create(symbol, *a, **kw) : Repository
      key = { {{ @type }}, symbol }
      Register[key].new(*a, **kw).as(Repository)
    end
  end
end