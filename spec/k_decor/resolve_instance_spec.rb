# frozen_string_literal: true

require 'spec_helper'

require 'mocks/decorators/_'

RSpec.describe KDecor::ResolveInstance do
  include described_class

  subject { resolve_decorator_instance(decorator) }

  context 'when decorator is provided as class type' do
    let(:decorator) { PluralizeModelDecorator }

    it { is_expected.to be_a(PluralizeModelDecorator) }

    context 'but not descendent of BaseDecorator' do
      let(:decorator) { Object }

      it { expect { subject }.to raise_error(KType::Error, 'Class type is not a KDecor::BaseDecorator') }
    end
  end

  context 'when decorator is provided as instance' do
    let(:decorator) { PluralizeModelDecorator.new }

    it { is_expected.to be_a(PluralizeModelDecorator) }

    context 'but not descendent of BaseDecorator' do
      let(:decorator) { Object.new }

      it { expect { subject }.to raise_error(KType::Error, 'Class instance is not a KDecor::BaseDecorator') }
    end
  end
end
