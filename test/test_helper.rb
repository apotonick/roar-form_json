require 'roar/representer/json/form'
require 'minitest/spec'
require 'minitest/autorun'

MiniTest::Spec.class_eval do
  def self.representer!(format=Representable::Hash, name=:representer, &block)
    let(name) do
      Module.new do
        include format
        instance_exec(&block)
      end
    end
  end

  module TestMethods
    def representer_for(modules=[Representable::Hash], &block)
      Module.new do
        extend TestMethods
        include *modules
        module_exec(&block)
      end
    end
  end
  include TestMethods
end
