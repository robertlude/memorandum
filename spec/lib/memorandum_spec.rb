require 'spec_helper'

describe Memorandum do
  # Subject

  subject do
    test_class.tap do |klass|
      # doing this here rather than in `create_test_class` to emphasize that
      # we are testing memorandum and not the test class

      next if test_class_already_memoized

      klass.extend(described_class)
      klass.send(:memo, method_name)
    end
  end

  # Lets

  let(:instance)                    { subject.new }
  let(:method_name)                 { "method_#{SecureRandom.uuid.tr '-', '_'}" }
  let(:test_class)                  { create_test_class(method_name) { } }
  let(:test_class_already_memoized) { false }

  let :test_class do
    Class.new.tap do |test_class|
      test_class.send :define_method, method_name do
        SecureRandom.uuid
      end
    end
  end

  # Wrappers

  before do
    Thread.current.thread_variable_set :test_method_call_count, 0
  end

  # Tests

  describe '.memo' do
    it 'preserves the original method name' do
      expect(instance).to respond_to method_name
    end

    it 'returns the same value on subsequent calls' do
      result1 = instance.send method_name
      result2 = instance.send method_name
      expect(result1).to eq result2
    end

    it 'does not call the original method more than once' do
      Thread.current.thread_variable_set :test_method_call_count, 0

      test_class = Class.new.tap do |test_class|
                     test_class.extend described_class

                     test_class.send :define_method, method_name do
                       count = Thread
                                 .current
                                 .thread_variable_get(:test_method_call_count)

                       Thread
                         .current
                         .thread_variable_set(
                           :test_method_call_count,
                           count + 1,
                         )
                     end

                     test_class.memo method_name
                   end

      instance = test_class.new

      instance.public_send method_name
      instance.public_send method_name

      count = Thread.current.thread_variable_get :test_method_call_count

      expect(count).to be 1
    end

    context 'when the original method returns nil' do
      let :test_class do
        Class.new.tap do |test_class|
          test_class.send :define_method, method_name do
          end
        end
      end

      it 'memoizes nil' do
        expect(instance.send method_name).to be nil
      end
    end

    context 'when the original method accepts arguments' do
      let :test_class do
        Class.new.tap do |test_class|
          test_class.send :define_method, method_name do |*args|
            SecureRandom.uuid
          end
        end
      end

      it 'caches per combination of arguments' do
        args_a = Array.new(rand 1..10) { rand }
        args_b = Array.new(rand 1..10) { rand }

        result_a1 = instance.send method_name, *args_a
        result_a2 = instance.send method_name, *args_a
        expect(result_a1).to eq result_a2

        result_b1 = instance.send method_name, *args_b
        result_b2 = instance.send method_name, *args_b
        expect(result_a1).to eq result_a2
      end
    end

    context 'when given a "freeze" flag' do
      let(:test_class_already_memoized) { true }

      let :test_class do
        Class.new.tap do |test_class|
          test_class.extend described_class

          test_class.send :define_method, method_name do
            SecureRandom.uuid
          end

          test_class.memo :freeze, method_name
        end
      end

      it 'freezes the value' do
        value = instance.public_send method_name

        expect(value).to be_frozen
      end
    end

    context 'when given a "deep_freeze" flag' do
      let(:test_class_already_memoized) { true }

      let :test_class do
        Class.new.tap do |test_class|
          test_class.extend described_class

          test_class.send :define_method, method_name do
            Hash child: SecureRandom.uuid
          end

          test_class.memo :deep_freeze, method_name
        end
      end

      it 'deep freezes the value' do
        value = instance.public_send method_name

        expect(value).to be_frozen
        expect(value[:child]).to be_frozen
      end
    end

    shared_examples 'special character tests' do
      it 'does not raise an error' do
        expect { instance.send method_name }.not_to raise_error
      end

      it 'memoizes properly' do
        result_a = instance.send method_name
        result_b = instance.send method_name
        expect(result_a).to be result_b
      end
    end

    %w[? ! =].each do |string|
      context "when the method name ends with '#{string}'" do
        let(:method_name) { "#{super()}#{string}" }

        include_examples 'special character tests'
      end
    end

    %w[! [] == + - * ** / % << >> & ^ | < > <= => <=> === != =~ !~].each do |operator|
      context "when the method name is operator '#{operator}'" do
        let(:method_name) { operator }

        include_examples 'special character tests'
      end
    end

    context 'when the original method is public' do
      it 'replaces the method with one of the same method type' do
        expect(instance.public_methods).to include method_name.to_sym
      end
    end

    context 'when the original method is private' do
      let :test_class do
        super().tap do |test_class|
          test_class.send :private, method_name
        end
      end

      it 'replaces the method with one of the same method type' do
        expect(instance.private_methods).to include method_name.to_sym
      end
    end

    context 'when the original method is protected' do
      let :test_class do
        super().tap do |test_class|
          test_class.send :protected, method_name
        end
      end

      it 'replaces the method with one of the same method type' do
        expect(instance.protected_methods).to include method_name.to_sym
      end
    end
  end

  describe '#memorandum_reset' do
    it 'resets memorandum\'s cache for that method' do
      first_result = instance.public_send method_name

      instance.memorandum_reset method_name

      second_result = instance.public_send method_name

      expect(first_result).not_to eq second_result
    end
  end
end
