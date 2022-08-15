require "json"

module JSON
  struct Diff
    enum Type
      Type
      Size
      Value
    end
  
    getter path : String
    getter base : Any?
    getter other : Any?
    getter type : Type
  
    def initialize(@path, @base, @other, @type=Type::Value)
    end
  end

  struct Any
    def diff(other : JSON::Any?, path="", &block : Diff->)
      if other.nil?
        yield Diff.new(path, self, other)
      elsif hash = as_h?
        other_h = other.as_h?
        if other_h.nil?
          yield Diff.new(path, self, other)
          return
        end
        hash.each_with_index do |kv, i|
          key, value = kv
          new_path = "#{path}.#{key}"
          value.diff other_h[key]?, path:new_path, &block
        end
      elsif array = as_a?
        other_a = other.as_a?
        if other_a.nil?
          yield Diff.new(path, self, other, Diff::Type::Type)
        elsif array.size != other_a.size
          yield Diff.new(path, self, other, Diff::Type::Size)
        else
          array.zip(other_a).each_with_index do |pair, i|
            item, other_item = pair
            new_path = "#{path}[#{i}]"
            item.diff other_item, path:new_path, &block
          end
        end
      else
        if self != other
          yield Diff.new(path, self, other)
        end
      end
    end
  end
end
