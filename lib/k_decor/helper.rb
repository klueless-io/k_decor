# frozen_string_literal: true

module KDecor
  # KDoc.settings :x, decorators: [Class, Class.instance, :class] do
  #   #
  # end

  class Helper
    include KDecor::ResolveInstance

    # Resolve decorator instances by evaluating a list of decorators in the format
    # :symbol, class or :class_instance
    #
    # :symbol will be looked up from pre-configured decorators
    # :class will be instantiated
    # :class_instance will be returned as is
    #
    # @example Sample of how decorators can be passed
    #
    #   decorators(:uppercase, PeopleModelDecorator, PluralizeModelDecorator.new('Person' => 'People') })
    #
    # @param [Array<Symbol,Class<BaseDecorator>|Instance<BaseDecorator>>] decorators provide a list of
    # decorators as either Class or Instances or pre-configured symbols
    def resolve_decorators(decorators)
      decorators.map do |decorator|
        if decorator.is_a?(Symbol)
          KDecor.configuration.get_decorator(decorator)
        else
          resolve_decorator_instance(decorator)
        end
      end.compact
    end

    # Run a list of decorators against the data
    def decorate(data, *decorators, behaviour: :default, behaviours: [])
      if behaviours.length.zero?
        decorators.map do |decorator|
          decorator.decorate(data, behaviour: behaviour)
        end
      else
        behaviours.each do |behave|
          decorators.map do |decorator|
            decorator.decorate(data, behaviour: behave)
          end
        end
      end
      data
    end

    # decorate(data, [](:plural, PluralizeModelDecorator)
    # config.register_decorator(:plural_configured, PluralizeModelDecorator.new('Person' => 'People'))
    # config.register_decorator(:people, PeopleModelDecorator)
  end
end
