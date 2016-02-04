require 'spec_helper'

describe Memorandum do
  # Subject

  subject do
    klass = Class.new do
      def an_instance_method_returning_nil
        nil
      end

      def an_instance_method_returning_not_nil
        SecureRandom.uuid
      end
    end
    klass.extend described_class
    klass
  end

  # Helpers

  def call_memoized args
    instance.send memo_method_name, *args
  end

  # Shared Groups

  shared_examples_for 'proper memoization' do
    it 'creates a method with the supplied name' do
      expect(instance).to respond_to memo_method_name
    end

    it 'returns the same value for the same arguments on subsequent calls' do
      memo_method_args.each do |args|
        expect(call_memoized args)
        .to eq call_memoized args
      end
    end

    it 'only calls the block once the first time per set of arguments' do
      expect(instance)
      .to receive(target_method)
      .exactly(memo_method_args.length).times

      memo_method_args.each do |args|
        instance.send memo_method_name, *args
        instance.send memo_method_name, *args
      end
    end
  end

  # Tests

  it { is_expected.to respond_to :memo }

  describe '.memo' do
    let(:instance)         { subject.new }
    let(:memo_method_name) { SecureRandom.uuid.tr '-', '_' }
    let(:memo_method_args) {
      [
        Array.new,
        *Array.new(2) { Array.new(rand 1..5) { SecureRandom.uuid } },
      ]
    }


    context 'when the memoized value is nil' do
      let(:target_method) { :an_instance_method_returning_nil }
      before { subject.memo(memo_method_name) { |*args| an_instance_method_returning_nil } }
      include_examples 'proper memoization'
    end

    context 'when the memoized value is not nil' do
      let(:target_method) { :an_instance_method_returning_not_nil }
      before { subject.memo(memo_method_name) { |*args| an_instance_method_returning_not_nil } }
      include_examples 'proper memoization'
    end
  end
end
