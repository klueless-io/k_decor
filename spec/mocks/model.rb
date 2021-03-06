# frozen_string_literal: true

class Model
  attr_accessor :model
  attr_accessor :model_plural
  attr_accessor :touch

  def initialize(name = nil, **params)
    @model = name
    @params = params
    @params.each { |key, value| send("#{key}=", value) }
  end

  def touched
    @touch = true
  end

  def to_h
    result = {
      model: @model,
      model_plural: @model_plural,
      touch: @touch
    }
    ps = @params.map { |key, _value| [key, send(key.to_s)] }
    ps.each do |current|
      key, value = current.first
      result[key] = value
    end
    result
  end
end
