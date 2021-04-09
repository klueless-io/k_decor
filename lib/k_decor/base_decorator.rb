# frozen_string_literal: true

require 'delegate'
module KDecor
  # Base decorator
  class BaseDecorator
    include KLog::Logging

    # Compatible type will store the Object Type that this decorator
    # is suitable for processing
    attr_accessor :compatible_type

    # What behaviours are available to this decorator, any base decorator
    # may be called from multiple places with slightly different behaviours.
    #
    # These behaviours can be listed on the base class and they provide
    # some safety against calling child decorators incorrectly.
    attr_accessor :available_behaviours

    # What are the specific behaviours of this decorator
    #
    # If you wish to use a decorator to run against a compatible data type
    # and not worry about what method fired the decorator then leave
    # the behaviour as :all
    #
    # But if this decorator type only targets certain behaviours then give it a
    # specific :behaviour to perform. e.g. KDecor::TableDecorator can
    # be responsible for updating rows, fields or both.
    attr_accessor :implemented_behaviours

    def initialize(compatible_type)
      @compatible_type = compatible_type
      @available_behaviours = [:default]
      @implemented_behaviours = []
    end

    # Does the decorator implement the behaviour
    # , any = false)
    def behaviour?(behaviour)
      # (any == true && behaviours.include?(:all)) ||
      behaviours.include?(behaviour)
      # required_behaviours.any? { |required_behaviour| behaviours.include?(required_behaviour) }
    end

    def compatible?(target)
      target.is_a?(compatible_type)
    end

    def decorate(target, **opts)
      raise KType::Error, "#{self.class} is incompatible with data object" unless compatible?(target)
      raise KType::Error, "#{self.class} has not implemented an update method" unless respond_to?(:update)

      update(target, **opts)
    end
  end
end
