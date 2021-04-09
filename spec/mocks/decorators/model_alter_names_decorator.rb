# frozen_string_literal: true

class ModelAlterNamesDecorator < ModelDecorator
  def update(target, **_opts)
    # target.respond_to?(:first_name) - need to work out what to do when working with account which does not have first_name, lastname

    target.first_name = target.first_name.gsub('David', 'Dave') unless target.first_name.nil?
    target.last_name = target.last_name.gsub('Cruwys', 'was here') unless target.last_name.nil?

    target
  end
end
