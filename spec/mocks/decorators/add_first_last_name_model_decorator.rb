# frozen_string_literal: true

# Update the structure of the model by attaching new attributes (:first_name, :last_read)
class AddFirstLastNameModelDecorator < ModelDecorator
  def update(target, **_opts)
    target.class.send(:attr_accessor, :first_name) unless target.respond_to?(:first_name)
    target.class.send(:attr_accessor, :last_name) unless target.respond_to?(:last_name)

    target
  end
end
