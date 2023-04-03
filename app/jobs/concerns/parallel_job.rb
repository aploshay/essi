# inclusion selectively overrides SequentialJob module
module ParallelJob
  def self.prepended(mod)
    mod.singleton_class.prepend(ClassMethods)
  end

  module ClassMethods
    def run_sequentially?
      false
    end
  end
end
