# frozen_string_literal: true

require 'mocks/model'

class ModelPluralizeDecorator < ModelDecorator
  def update(target, **opts)
    super(target, **opts)

    target.model_plural = "#{target.model}s" if !target.model.nil? && target.model_plural.nil?

    target
  end
end
