# frozen_string_literal: true

class ModelAddFullNameDecorator < ModelDecorator
  def update(target, **_opts)

    target.class.send(:attr_accessor, :full_name) unless target.respond_to?(:full_name)
    target.full_name = "#{target.first_name} #{target.last_name}"

    target
  end
end
