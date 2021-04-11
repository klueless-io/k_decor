# frozen_string_literal: true

module KDecor
  # Configuration class for KDecor
  class Configuration
    attr_accessor :decorators

    def initialize
      @decorators = KDecor::DecoratorHash.new
    end

    def register_decorator(key, decorator)
      decorators.add(key, decorator)
    end

    def get_decorator(key)
      decorators[key]
    end
  end
end
