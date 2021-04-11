# frozen_string_literal: true

module KDecor
  # Decorator set will hold a set of instantiated decorators with lookup keys
  class DecoratorHash < Hash
    include KDecor::ResolveInstance
    include KLog::Logging

    # Add a keyed decorator to the store.
    #
    # @param [Symbol] key lookup key that can be used when retrieving the decorator
    def add(key, decorator)
      if key?(key)
        log.warn("Decorator with this key '#{key}' already in the stored")
        return
      end

      self[key] = resolve_decorator_instance(decorator)
      nil
    end

    # def decorators(decorators)
    #   return [] if decorators.nil?

    #   decorators.map do |decorator|
    #     if decorator.is_a?(Class)
    #       handle_class(decorator)
    #     elsif decorator.is_a?(Symbol)
    #       handle_symbol(decorator)
    #     else
    #       decorator
    #     end
    #   end.compact
    # end

    # def decorator_instance(decorator)
    #   if decorator.is_a?(Class)
    #     return decorator.new if decorator.ancestors.include?(KDecor::BaseDecorator)

    #     raise KType::Error, 'Class type is not a KDecor::BaseDecorator'
    #   end

    #   raise KType::Error, 'Class instance is not a KDecor::BaseDecorator' unless decorator.is_a?(KDecor::BaseDecorator)

    #   decorator
    # end

    # def handle_symbol(decorator)
    #   result = KDsl.config.get_decorator(decorator)&.new
    #   result = nil unless result.respond_to?(:update)
    #   result
    # end
  end
end
