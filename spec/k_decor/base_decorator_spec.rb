# frozen_string_literal: true

require 'spec_helper'

# require 'active_support/core_ext/string'

require 'mocks/model'
require 'mocks/model_account'
require 'mocks/model_person'
require 'mocks/decorators/model_decorator'
require 'mocks/decorators/model_pluralize_decorator'
require 'mocks/decorators/model_todo_decorator'
require 'mocks/decorators/model_alter_names_decorator'
require 'mocks/decorators/model_add_full_name_decorator'

# require 'mocks/decorators/set_db_type_table_decorator'
# require 'mocks/decorators/set_entity_fields_table_decorator'

RSpec.describe KDecor::BaseDecorator do
  let(:data) { {} }
  let(:data_account) { ModelAccount.new }
  let(:data_person) { ModelPerson.new }
  let(:data_person_david) { ModelPerson.new(first_name: 'David', last_name: 'Cruwys') }
  let(:data_person_john) { ModelPerson.new(first_name: 'John', last_name: 'Doe') }

  describe 'check starting data' do
    context 'ModelAccount' do
      subject { data_account }
      it {
        is_expected.to have_attributes(model: 'Account',
                                       model_plural: nil,
                                       touch: nil)
      }
    end
    context 'ModelPerson' do
      subject { data_person }
      it {
        is_expected.to have_attributes(model: 'Person',
                                       model_plural: nil,
                                       touch: nil)
      }
    end
    context 'ModelPerson - David' do
      subject { data_person_david }
      it {
        is_expected.to have_attributes(model: 'Person',
                                       model_plural: nil,
                                       touch: nil,
                                       first_name: 'David',
                                       last_name: 'Cruwys')
      }
    end
    context 'ModelPerson - John' do
      subject { data_person_john }
      it {
        is_expected.to have_attributes(model: 'Person',
                                       model_plural: nil,
                                       touch: nil,
                                       first_name: 'John',
                                       last_name: 'Doe')
      }
    end
  end

  describe '#initialize' do
    subject { decorator }

    context 'when base decorator' do
      let(:decorator) { KDecor::BaseDecorator.new(Object) }

      it { is_expected.not_to be_nil }

      context '.compatible_type' do
        subject { decorator.compatible_type }

        it { is_expected.to eq(Object) }
      end

      context '.available_behaviours' do
        subject { decorator.available_behaviours }

        it { is_expected.to eq([:default]) }
      end

      context '.implemented_behaviours' do
        subject { decorator.implemented_behaviours }

        it { is_expected.to be_empty }
      end
    end

    context 'when simple decorator' do
      let(:decorator) { ModelDecorator.new }

      it { is_expected.not_to be_nil }

      context '.compatible_type' do
        subject { decorator.compatible_type }

        it { is_expected.to eq(Model) }
      end

      context '.available_behaviours' do
        subject { decorator.available_behaviours }

        it { is_expected.to eq([:default]) }
      end

      context '.implemented_behaviours' do
        subject { decorator.implemented_behaviours }

        it { is_expected.to eq([:default]) }
      end
    end
  end

  describe '#compatible?' do
    subject { decorator.compatible?(target) }

    context 'when compatible with any object' do
      let(:decorator) { KDecor::BaseDecorator.new(Object) }

      context 'when Hash' do
        let(:target) { {} }

        it { is_expected.to be_truthy }
      end

      context 'when String' do
        let(:target) { 'blah' }

        it { is_expected.to be_truthy }
      end
    end

    context 'when compatible with specific object' do
      let(:decorator) { ModelDecorator.new }

      context 'when Hash' do
        let(:target) { {} }

        it { is_expected.to be_falsey }
      end

      context 'when ModelPerson' do
        let(:target) { data_person }

        it { is_expected.to be_truthy }
      end

      context 'when ModelAccount' do
        let(:target) { data_account }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#decorate' do
    subject { decorator.decorate(data) }

    context 'when data is incompatible with the decorator' do
      let(:data) { {} }
      let(:decorator) { ModelDecorator.new }

      it { expect { subject }.to raise_error(KType::Error, 'ModelDecorator is incompatible with data object') }
    end

    context 'when decorator has not implemented an update method' do
      let(:data) { Model.new }
      let(:decorator) { ModelTodoDecorator.new }

      it { expect { subject }.to raise_error(KType::Error, 'ModelTodoDecorator has not implemented an update method') }
    end

    context 'when data is compatible' do
      let(:data) { Model.new }
      let(:decorator) { ModelDecorator.new }

      it { is_expected.to eq(data) }
    end
  end

  context 'simple decorators having behaviour: :default' do
    subject { decorator.decorate(data) }

    context 'when ModelAccount is decorated by ModelDecorator' do
      let(:decorator) { ModelDecorator.new }

      let(:data) { data_account }

      it {
        is_expected.to have_attributes(model: 'Account',
                                       touch: true)
      }
    end

    context 'when ModelAccount is decorated by ModelPluralizeDecorator' do
      let(:decorator) { ModelPluralizeDecorator.new }

      let(:data) { data_account }

      it do
        is_expected.to have_attributes(model: 'Account',
                                       model_plural: 'Accounts',
                                       touch: true)
      end
    end

    context 'when ModelPersonDavid is decorated by ModelAlterNamesDecorator' do
      let(:decorator) { ModelAlterNamesDecorator.new }

      let(:data) { data_person_david }

      it {
        is_expected.to have_attributes(model: 'Person',
                                       touch: nil,
                                       first_name: 'Dave',
                                       last_name: 'was here')
      }
    end

    context 'when ModelPersonData is decorated by ModelAddFullNameDecorator' do
      let(:decorator) { ModelAddFullNameDecorator.new }

      let(:data) { data_person_david }

      it {
        is_expected.to have_attributes(model: 'Person',
                                       touch: nil,
                                       first_name: 'David',
                                       last_name: 'Cruwys',
                                       full_name: 'David Cruwys')
      }
    end
  end

  # The following simple decorator should be wrapped up in a complex behaviour 
  # context 'simple decorators that exhibit complex behaviour' do

  #   context 'when decorator is compatible_with data class, but not this particular sub_class' do
  #     let(:decorator) { ModelAddFullNameDecorator.new }

  #     let(:data) { data_account }

  #     it { expect { subject }.to raise_error }
  #   end

  # end
end
