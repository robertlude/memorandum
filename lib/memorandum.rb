module Memorandum
  def memo name, &memoizer
    memoized_statuses = "@memoized_statuses_for_#{name}"
    memoized_values   = "@memoized_values_for_#{name}"
    memoizer_name     = "memoizer_for_#{name}"

    define_method memoizer_name, &memoizer

    send :define_method, name do |*args|
      statuses = instance_variable_get(memoized_statuses) \
        || instance_variable_set(memoized_statuses, Hash[])

      values = instance_variable_get(memoized_values) \
        || instance_variable_set(memoized_values, Hash[])

      unless statuses[args]
        values[args]   = send memoizer_name, *args
        statuses[args] = true
      end
      values[args]
    end
  end
end
