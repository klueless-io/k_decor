# frozen_string_literal: true

RSpec.describe KDecor do
  it 'has a version number' do
    expect(KDecor::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise KDecor::Error, 'some message' }
      .to raise_error('some message')
  end
end
