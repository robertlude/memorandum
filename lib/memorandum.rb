require 'ice_nine'

module Memorandum
  def memo *arguments
    name = arguments.pop
    flags = arguments

    memoized_statuses = "@memoized_statuses_for_#{name}"
    memoized_values   = "@memoized_values_for_#{name}"
    unmemoized_name   = "unmemoized_#{name}"

    alias_method unmemoized_name, name

    define_method name do |*args|
      statuses = instance_variable_get(memoized_statuses) \
        || instance_variable_set(memoized_statuses, Hash[])

      values = instance_variable_get(memoized_values) \
        || instance_variable_set(memoized_values, Hash[])

      unless statuses[args]
        value = send unmemoized_name, *args

        value = value.freeze              if flags.include? :freeze
        value = IceNine.deep_freeze value if flags.include? :deep_freeze

        values[args]   = value
        statuses[args] = true
      end

      values[args]
    end
  end
end
