# frozen_string_literal: true

require 'mocks/model'

class ModelPerson < Model
  attr_accessor :first_name
  attr_accessor :last_name

  # This accessor will be added dynamically by ModelAddFullNameDecorator
  # attr_accessor :full_name

  def initialize(**params)
    super('Person', **params)
  end
end
