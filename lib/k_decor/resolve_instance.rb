# frozen_string_literal: true

module KDecor
  # Decorator set will hold a set of instantiated decorators with lookup keys
  module ResolveInstance
    # Decorator instance will accept a decorator in the form of Class or Instance
    #
    # @param [Class<BaseDecorator>|Instance<BaseDecorator>] decorator as either a class type or an instance that extends from BaseDecorator
    def resolve_decorator_instance(decorator)
      if decorator.is_a?(Class)
        return decorator.new if decorator.ancestors.include?(KDecor::BaseDecorator)

        raise KType::Error, 'Class type is not a KDecor::BaseDecorator'
      end

      raise KType::Error, 'Class instance is not a KDecor::BaseDecorator' unless decorator.is_a?(KDecor::BaseDecorator)

      decorator
    end
  end
end
