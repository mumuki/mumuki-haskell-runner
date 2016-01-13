require_relative './spec_helper'

describe ValidationHook do
  let(:hook) { ValidationHook.new(nil) }
  it 'should admit non malicious code' do
    expect(hook.unsafe? treq('x = 4')).to be false
  end

  it 'should admit non malicious code with imports' do
    expect(hook.unsafe? treq('x = 4', 'import Data.List\nx = 4')).to be false
  end

  it 'should detect System.IO.Unsafe imports' do
    expect(hook.unsafe? treq('import System.IO.Unsafe\nx = 4')).to be true
  end
end