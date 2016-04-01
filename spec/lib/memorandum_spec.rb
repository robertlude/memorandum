require 'spec_helper'

describe Memorandum do
  # Subject

  subject do
    test_class.tap do |klass|
      # doing this here rather than in `create_test_class` to emphasize that
      # we are testing memorandum and not the test class

      next if test_class_already_memoized

      klass.extend(Memorandum)
      klass.send(:memo, method_name)
    end
  end

  # Lets

  let(:instance)                    { subject.new }
  let(:method_name)                 { "method_#{SecureRandom.uuid.tr '-', '_'}" }
  let(:test_class)                  { create_test_class(method_name) { } }
  let(:test_class_already_memoized) { false }

  # Helpers

  def create_test_class method_name, &block
    Class.new { define_method method_name, block }
  end

  # Tests

  it 'provides a class method .memo' do
    expect(subject).to respond_to :memo
  end

  describe '.memo' do
    let(:test_class) { create_test_class(method_name) { rand } }

    it 'preserves the original method name' do
      expect(instance).to respond_to method_name
    end

    it 'returns the same value on subsequent calls' do
      result1 = instance.send method_name
      result2 = instance.send method_name
      expect(result1).to eq result2
    end

    it 'does not call the original method more than once' do
      test_class = Class.new do
                     extend Memorandum
                     def test_hook_method() end
                     def test() test_hook_method end
                     memo :test
                   end

      instance = test_class.new

      expect(instance).to receive(:test_hook_method).once

      instance.test
      instance.test
    end

    context 'when the original method returns nil' do
      let(:test_class) { create_test_class(method_name) { } }

      it 'memoizes nil' do
        expect(instance.send method_name).to be nil
      end
    end

    context 'when the original method accepts arguments' do
      let(:test_class) do
        create_test_class(method_name) { |*args| SecureRandom.uuid }
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
      let(:test_class) do
        Class.new do
          extend Memorandum
          def test() {} end
          memo :freeze, :test
        end
      end

      it 'freezes the value' do
        expect(instance.test).to be_frozen
      end
    end

    context 'when given a "deep_freeze" flag' do
      let(:test_class_already_memoized) { true }
      let(:test_class) do
        Class.new do
          extend Memorandum
          def test() {child: {}} end
          memo :deep_freeze, :test
        end
      end

      it 'deep freezes the value' do
        expect(instance.test).to be_frozen
        expect(instance.test[:child]).to be_frozen
      end
    end
  end
end
