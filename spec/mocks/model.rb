# frozen_string_literal: true

class Model
  attr_accessor :model
  attr_accessor :model_plural
  attr_accessor :touch

  def initialize(name = nil, **params)
    @model = name
    params.each { |key, value| send("#{key}=", value) }
  end

  def touched
    @touch = true
  end
end
