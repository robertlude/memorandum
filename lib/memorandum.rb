module Memorandum
  def memo name
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
        values[args]   = send unmemoized_name, *args
        statuses[args] = true
      end
      values[args]
    end
  end
end
