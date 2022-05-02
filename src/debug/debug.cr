module Cl::Debug
  def report_memory(title : String)
    m = Benchmark.memory do
      yield
    end
    puts "#{m.humanize(base: 1024)}\t#{title}"
  end

  def report_memory(cls : Class, &block)
    report_memory cls.name, &block
  end
end
