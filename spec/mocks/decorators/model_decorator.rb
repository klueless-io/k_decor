# frozen_string_literal: true

class ModelDecorator < KDecor::BaseDecorator
  def initialize
    super(Model)

    @implemented_behaviours = [:default]
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
  def update(target, **_opts)
    target.touched
    target
  end
end
