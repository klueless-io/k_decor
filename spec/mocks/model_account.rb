# frozen_string_literal: true

require 'mocks/model'

class ModelAccount < Model
  def initialize(**params)
    super('Account', **params)
  end
end
