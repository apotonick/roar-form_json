require "roar/representer/json"

module Roar::Representer::JSON
  module Form
    def self.included(base)
      base.class_eval do
        include Roar::Representer::JSON
        extend Roar::Representer::Feature::Hypermedia::InheritableArray
        extend ClassMethods
        include InstanceMethods
      end
    end

    #collection :elements

    module ClassMethods
      def text(name, options={})
        representable_attrs.inheritable_array(:elements) << {:type => :text, :name => name}.merge!(options)
      end
      def radio(name, options={})
        representable_attrs.inheritable_array(:elements) << {:type => :radio, :name => name}.merge!(options)
      end
      def select(name, options={}, &block)
        representable_attrs.inheritable_array(:elements) << {:type => :select, :name => name, :block => block}.merge!(options)
      end
    end

    module InstanceMethods
      def to_hash(*args)
        representable_attrs.inheritable_array(:elements).collect do |el|
          el[:data] = el.delete(:block).call(*args) if el[:block]
          el
        end
      end

      def from_hash(hash, *args)
        # FIXME: for now, we store it in another instance var, do it as it's done with Hyperlinks.
        @bla = hash
      end

      def element(name)
        @bla.find do |el|
          # TODO: stringify everything, damnit!
          el["name"].to_s == name.to_s
        end
      end
    end
  end
end
