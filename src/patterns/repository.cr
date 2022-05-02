module Cl::Patterns
  macro auto_wired
    1
  end

  abstract class Repository
    alias Key = Symbol | String
    Register = Hash(Tuple(Repository.class, Key), Repository.class).new
    DefaultRegister = Hash(Repository.class, Repository.class).new

    def self.new(*a, **kw)
    end

    def initialize(*a, **kw)
    end

    def self.set_default(cls, key)
      DefaultRegister[cls] = Register[{cls, key}]
    end

    def self.set_default_all(pairs : Hash(Repository.class, Key))
      pairs.each do |cls, key|
        self.set_default cls, key
      end
    end
    
    def self.create_for(symbol, *a, **kw) : Repository
      self.instantiate Register[{ {{ @type }}, symbol }]
    end

    def self.create(*a, **kw) : Repository
      self.instantiate DefaultRegister[{{ @type }}]
    end

    private def self.instantiate(cls, *a, **kw)
      instance = cls.new *a, **kw
      {{ @type }}.cast instance
    end

    macro inherited
      {% unless @type.abstract? %}
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
  end
end
