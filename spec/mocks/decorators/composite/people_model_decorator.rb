# frozen_string_literal: true

# This decorator implements many behaviours that can be called individually
class PeopleModelDecorator < KDecor::BaseDecorator
  def initialize
    super(Model)

    @implemented_behaviours = %i[touch pluralize alter_names add_full_name]
  end

  # An descendant to <BaseDecorator> should implement an update method,
  # which can either update the target data object directly or delegate
  # responsibility to implemented behaviours
  #
  # @param [Object<compatible_type>] target Target object to update,
  #                                  this object must be of type: .compatible_type
  # @param [Hash] **opts Any options that are passed in via the decorate method
  # @option opts [Symbol] :behaviour Behaviour is a common options that can be used
  #                                 to update specific parts of the target object
  def update(target, **opts)
    behaviour = opts[:behaviour]

    touch(target, **opts)                   if %i[all touch].include?(behaviour)
    pluralize_model_name(target, **opts)    if %i[all pluralize].include?(behaviour)
    alter_names(target, **opts)             if %i[all alter_names].include?(behaviour)
    add_full_name(target, **opts)           if %i[all add_full_name].include?(behaviour)

    target
  end

  def touch(target, **_opts)
    target.touched
  end

  def pluralize_model_name(target, **_opts)
    # You can write individual behaviours
    target.model_plural = "#{target.model}s" if !target.model.nil? && target.model_plural.nil?
  end

  def alter_names(target, **opts)
    # or wrap the target in a compatible decorator and call from the behaviour
    AlterNamesModelDecorator.new.decorate(target, **opts)
  end

  def add_full_name(target, **opts)
    AddFullNameModelDecorator.new.decorate(target, **opts)
  end
end
