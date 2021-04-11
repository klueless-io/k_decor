# frozen_string_literal: true

require 'spec_helper'

require 'mocks/decorators/_'

RSpec.describe KDecor::Helper do
  let(:instance) { described_class.new }

  describe 'module helper' do
    subject { KDecor.decorate }

    it { is_expected.not_to be_nil }
  end

  before do
    KDecor.configure do |config|
      config.register_decorator(:plural, PluralizeModelDecorator)
      config.register_decorator(:plural_configured, PluralizeModelDecorator.new('Person' => 'People'))
      config.register_decorator(:people, PeopleModelDecorator)
    end
  end
  after do
    KDecor.reset
  end

  describe '#resolve_decorators' do
    subject { instance.resolve_decorators(decorator_list) }

    context 'when symbol, class, invalid symbol and class instance' do
      let(:decorator_list) { [:plural, PeopleModelDecorator, :xmen, PluralizeModelDecorator.new('Person' => 'People')] }

      it do
        expect(subject[0]).to be_a(PluralizeModelDecorator)
        expect(subject[1]).to be_a(PeopleModelDecorator)
        expect(subject[2]).to be_a(PluralizeModelDecorator)
      end
    end
  end

  describe '#run_decorators' do
    subject { instance.run_decorators(decorators, data, behaviour: behaviour) }

    let(:data) { ModelPerson.new(first_name: 'David', last_name: 'Cruwys') }
    let(:decorators) { instance.resolve_decorators(decorator_list) }
    let(:behaviour) { :default }

    context 'when :plural' do
      let(:decorator_list) { [:plural] }

      it { is_expected.to have_attributes(model: 'Person', model_plural: 'Persons') }
    end

    context 'when configured instance class' do
      let(:decorator_list) { [PluralizeModelDecorator.new('Person' => 'People')] }

      it { is_expected.to have_attributes(model: 'Person', model_plural: 'People') }
    end

    context 'when composite class type' do
      let(:decorator_list) { [PeopleModelDecorator] }

      context 'with behaviour: all' do
        let(:behaviour) { :all }

        it { is_expected.to have_attributes(model: 'Person', model_plural: 'Persons', touch: true, first_name: 'Dave', last_name: 'was here', full_name: 'Dave was here') }
      end

      context 'with behaviour: add_full_name' do
        let(:behaviour) { :add_full_name }

        it { is_expected.to have_attributes(model: 'Person', model_plural: nil, touch: nil, first_name: 'David', last_name: 'Cruwys', full_name: 'David Cruwys') }
      end
    end
  end
end
