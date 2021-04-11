# frozen_string_literal: true

module KDecor
  # Base decorator
  class BaseDecorator
    include KLog::Logging

    # Compatible type will store the Object Type that this decorator
    # is suitable for processing
    attr_accessor :compatible_type

    # What are the specific behaviours available on this decorator
    #
    # If you wish to use a decorator to run against a compatible data
    # type you do not need individual behaviours then set
    # implemented_behaviours to [:default]
    #
    # But if this decorator type only targets certain behaviours then give it a
    # list of specific :behaviour to perform. e.g. [:update_fields, :update_rows]
    attr_accessor :implemented_behaviours

    def initialize(compatible_type)
      @compatible_type = compatible_type
      @implemented_behaviours = []
    end

    # Does the decorator implement the behaviour
    # , any = false)
    def behaviour?(behaviour)
      behaviour == :all || implemented_behaviours.include?(behaviour)
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
