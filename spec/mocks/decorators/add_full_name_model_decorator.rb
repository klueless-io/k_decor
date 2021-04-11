# frozen_string_literal: true

# Update the structure of the model by attaching new attribute :full_name if not found
# and then build full_name from first_name and last_name
class AddFullNameModelDecorator < ModelDecorator
  def update(target, **_opts)
    target.class.send(:attr_accessor, :full_name) unless target.respond_to?(:full_name)
    target.full_name = "#{target.first_name} #{target.last_name}"

    target
  end
end
