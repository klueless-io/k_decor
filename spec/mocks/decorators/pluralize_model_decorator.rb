# frozen_string_literal: true

require 'mocks/model'

class PluralizeModelDecorator < ModelDecorator
  attr_accessor :mappings

  def initialize(mappings = {})
    super()

    @mappings = mappings
  end

  def update(target, **opts)
    super(target, **opts)

    if !target.model.nil? && target.model_plural.nil?
      target.model_plural = if mappings.key?(target.model)
                              mappings[target.model]
                            else
                              "#{target.model}s"
                            end
    end

    target
  end
end
