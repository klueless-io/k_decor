# frozen_string_literal: true

require 'spec_helper'
require 'mocks/decorators/_'

RSpec.describe KDecor do
  describe '.configuration' do
    subject { KDecor.configuration.decorators }

    it { is_expected.to be_empty }

    describe '#configure' do
      before do
        KDecor.configure do |config|
          config.register_decorator(:plural1, PluralizeModelDecorator)
          config.register_decorator(:plural2, PluralizeModelDecorator.new)
          config.register_decorator(:plural3, PluralizeModelDecorator.new('Person' => 'People'))
          config.register_decorator(:people, PeopleModelDecorator)
        end
      end

      after { KDecor.reset }

      it do
        is_expected.to include(
          plural1: be_a(PluralizeModelDecorator),
          plural2: be_a(PluralizeModelDecorator),
          plural3: be_a(PluralizeModelDecorator),
          people: be_a(PeopleModelDecorator)
        )
      end

      describe '#get_decorator' do
        subject { KDecor.configuration.get_decorator(decorator) }

        context 'when plural1' do
          let(:decorator) { :plural1 }
          it { is_expected.to be_a(PluralizeModelDecorator) }
        end

        context 'when people' do
          let(:decorator) { :people }
          it { is_expected.to be_a(PeopleModelDecorator) }
        end
      end
    end
  end
end
