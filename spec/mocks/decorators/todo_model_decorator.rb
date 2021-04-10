# frozen_string_literal: true

require 'mocks/model'

class TodoModelDecorator < KDecor::BaseDecorator
  def initialize
    super(Model)
  end

  # TODO: You need to implement an update method
end
