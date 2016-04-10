require 'ice_nine'

module Memorandum
  def memo *arguments
    name = arguments.pop
    flags = arguments

    memoized_statuses = memorandum_ivar_name MEMORANDUM_STATUSES, name
    memoized_values   = memorandum_ivar_name MEMORANDUM_VALUES, name
    unmemoized_name   = "#{MEMORANDUM_UNMEMOIZED}_#{name}"

    alias_method unmemoized_name, name

    define_method name do |*args|
      statuses = memorandum_fetch memoized_statuses, Hash[]
      values   = memorandum_fetch memoized_values,   Hash[]

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

  private

  MEMORANDUM_MEMOIZED   = 'memoized'.freeze
  MEMORANDUM_STATUSES   = 'statuses'.freeze
  MEMORANDUM_UNMEMOIZED = 'unmemoized'.freeze
  MEMORANDUM_VALUES     = 'values'.freeze
  MEMORANDUM_BANG       = '__BANG__'.freeze
  MEMORANDUM_BOOL       = '__BOOL__'.freeze

  def memorandum_ivar_name name, method_name
    "@#{MEMORANDUM_MEMOIZED}_#{name}_for_#{method_name}"
    .gsub('!', MEMORANDUM_BANG)
    .gsub('?', MEMORANDUM_BOOL)
  end

  module InstanceMethods
    def memorandum_fetch name, default
      instance_variable_get(name) || instance_variable_set(name, default)
    end
  end
end
