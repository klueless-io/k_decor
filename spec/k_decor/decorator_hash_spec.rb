# frozen_string_literal: true

require 'spec_helper'

require 'mocks/decorators/_'

RSpec.describe KDecor::DecoratorHash do
  let(:instance) { described_class.new }

  # models
  let(:data_account) { ModelAccount.new }
  let(:data_person) { ModelPerson.new }
  let(:data_person_david) { ModelPerson.new(first_name: 'David', last_name: 'Cruwys') }
  let(:data_person_john) { ModelPerson.new(first_name: 'John', last_name: 'Doe') }

  # decorators
  let(:pluralize) { PluralizeModelDecorator }
  let(:pluralize_instance) { PluralizeModelDecorator.new }
  let(:pluralize_instance_configured) { PluralizeModelDecorator.new('Person' => 'People') }
  let(:alter_names) { AlterNamesModelDecorator }
  let(:add_full_name) { AddFullNameModelDecorator }
  let(:add_first_last_name) { AddFirstLastNameModelDecorator }
  let(:composite_people) { PeopleModelDecorator }

  describe '#add' do
    subject { instance }

    context 'rules for duplicate key' do
      before { instance.add(:plural, pluralize) }

      it { is_expected.to have_attributes(length: 1) }

      describe '[:plural]' do
        subject { instance[:plural] }
        it { is_expected.to be_a(PluralizeModelDecorator) }
      end

      context 'add different decorator to same key' do
        # Using an existing key should not update the store
        # It should should also render a warning message
        before { instance.add(:plural, alter_names) }

        it { is_expected.to have_attributes(length: 1) }

        describe '[:plural]' do
          subject { instance[:plural] }
          it { is_expected.to be_a(PluralizeModelDecorator) }
        end
      end
    end

    context 'handle class or instance decorators' do
      subject do
        instance.add(:plural, decorator)
        instance[:plural]
      end

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
  end
end
# it { is_expected.to have_attributes(model: 'Person', model_plural: 'Persons') }
