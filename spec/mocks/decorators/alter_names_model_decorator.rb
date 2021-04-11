# frozen_string_literal: true

class AlterNamesModelDecorator < ModelDecorator
  def update(target, **_opts)
    target.first_name = target.first_name.gsub('David', 'Dave') unless target.first_name.nil?
    target.last_name = target.last_name.gsub('Cruwys', 'was here') unless target.last_name.nil?

    target
  end
end
