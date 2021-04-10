# frozen_string_literal: true

require 'spec_helper'
require 'json'
# require 'active_support/core_ext/string'

require 'mocks/model'
require 'mocks/model_account'
require 'mocks/model_person'
require 'mocks/decorators/composite/people_model_decorator'
require 'mocks/decorators/model_decorator'
require 'mocks/decorators/pluralize_model_decorator'
require 'mocks/decorators/todo_model_decorator'
require 'mocks/decorators/alter_names_model_decorator'
require 'mocks/decorators/add_full_name_model_decorator'
require 'mocks/decorators/add_first_last_name_model_decorator'

# require 'mocks/decorators/set_db_type_table_decorator'
# require 'mocks/decorators/set_entity_fields_table_decorator'

RSpec.describe KDecor::BaseDecorator do
  include KLog::Logging

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
      # fit { log.json(subject.to_h) }
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

      context '.implemented_behaviours' do
        subject { decorator.implemented_behaviours }

        it { is_expected.to eq([:default]) }
      end

      context '.behaviour?' do
        context 'when specific behaviour is implemented' do
          subject { decorator.behaviour?(:default) }

          it { is_expected.to be_truthy }
        end
        context 'when :all override is supplied' do
          subject { decorator.behaviour?(:all) }

          it { is_expected.to be_truthy }
        end
        context 'when specific behaviour is not implemented' do
          subject { decorator.behaviour?(:unknown) }

          it { is_expected.to be_falsey }
        end
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
      let(:decorator) { TodoModelDecorator.new }

      it { expect { subject }.to raise_error(KType::Error, 'TodoModelDecorator has not implemented an update method') }
    end

    context 'when data is compatible' do
      let(:data) { Model.new }
      let(:decorator) { ModelDecorator.new }

      it { is_expected.to eq(data) }
    end
  end

  context 'simple decorators' do
    subject { decorator.decorate(data) }

    context 'when ModelAccount is decorated by ModelDecorator' do
      let(:decorator) { ModelDecorator.new }

      let(:data) { data_account }

      it {
        is_expected.to have_attributes(model: 'Account',
                                       touch: true)
      }
    end

    context 'when ModelAccount is decorated by PluralizeModelDecorator' do
      let(:decorator) { PluralizeModelDecorator.new }

      let(:data) { data_account }

      it do
        is_expected.to have_attributes(model: 'Account',
                                       model_plural: 'Accounts',
                                       touch: true)
      end
    end

    context 'when ModelPersonDavid is decorated by AlterNamesModelDecorator' do
      let(:decorator) { AlterNamesModelDecorator.new }

      let(:data) { data_person_david }

      it {
        is_expected.to have_attributes(model: 'Person',
                                       touch: nil,
                                       first_name: 'Dave',
                                       last_name: 'was here')
      }
    end

    context 'when ModelPersonData is decorated by AddFullNameModelDecorator' do
      let(:decorator) { AddFullNameModelDecorator.new }

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

  # The following simple decorator should be wrapped up in a complex behaviours
  context 'simple decorators that exhibit complex behaviour' do
    subject { decorator.decorate(data) }

    context 'when decorator is compatible_with data type, but incompatible with the fields on the sub_class' do
      let(:decorator) { AddFullNameModelDecorator.new }

      let(:data) { data_account }

      it { expect { subject }.to raise_error(NoMethodError) }

      context 'make fields on sub_class compatible using AddFirstLastNameModelDecorator' do
        let(:decorator) { AddFirstLastNameModelDecorator.new }
  
        let(:data) { data_account }
  
        it {
          is_expected.to have_attributes(model: 'Account',
                                         touch: nil,
                                         first_name: nil,
                                         last_name: nil)
        }

        context 'now that fields are compatible, use the previously incompatible decorator' do
          let(:decorator) { AddFullNameModelDecorator.new }

          before {
            data.first_name = 'First'
            data.last_name = 'Last'
          }

          it {
            is_expected.to have_attributes(model: 'Account',
            touch: nil,
            first_name: 'First',
            last_name: 'Last',
            full_name: 'First Last')
          }
        end       
      end
    end
  end

  # context 'ModelPerson - John' do
  #   subject { data_person_john }
  #   it {
  #     is_expected.to have_attributes(model: 'Person',
  #                                    model_plural: nil,
  #                                    touch: nil,
  #                                    first_name: 'John',
  #                                    last_name: 'Doe')
  #   }
  # end

  context 'complex/composite decorators' do
    subject { decorator.decorate(data, behaviour: behaviour) }

    context 'using the people model decorator' do
      let(:decorator) { PeopleModelDecorator.new }

      context 'with all behaviours' do
        let(:behaviour) { :all }

        context 'for david' do
          let(:data) { data_person_david }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: 'Persons',
              touch: true,
              first_name: 'Dave',
              last_name: 'was here')
          }
        end
        
        context 'for john' do
          let(:data) { data_person_john }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: 'Persons',
              touch: true,
              first_name: 'John',
              last_name: 'Doe')
          }
        end
      end

      context 'with one behaviour: :alter_names' do
        let(:behaviour) { :alter_names }

        context 'for david' do
          let(:data) { data_person_david }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: nil,
              touch: nil,
              first_name: 'Dave',
              last_name: 'was here')
          }
        end
        
        context 'for john' do
          let(:data) { data_person_john }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: nil,
              touch: nil,
              first_name: 'John',
              last_name: 'Doe')
          }
        end
      end

      context 'with chained behaviours [:touch, :pluralize, :alter_names, :add_full_name]' do
        subject { data }

        let(:behaviours) { [:touch, :pluralize, :alter_names, :add_full_name] }

        before {
          behaviours.each { |behaviour| decorator.decorate(data, behaviour: behaviour) }
        }

        context 'for david' do
          let(:data) { data_person_david }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: 'Persons',
              touch: true,
              first_name: 'Dave',
              last_name: 'was here')
          }
        end
        
        context 'for john' do
          let(:data) { data_person_john }

          it {
            is_expected.to have_attributes(
              model: 'Person',
              model_plural: 'Persons',
              touch: true,
              first_name: 'John',
              last_name: 'Doe')
          }
        end
      end

    end
  end
end
