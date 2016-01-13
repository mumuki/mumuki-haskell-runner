require_relative './spec_helper'

describe QueryHook do
  let(:hook) { QueryHook.new(nil) }
  let(:result) { hook.run!(request) }

  let(:okQuery) { 'foo 3' }
  let(:okShowFunction) { 'even' }

  let(:okCodeOnExtra) { 'foo = bar' }
  let(:okCode) { 'foo = (*2)' }

  let(:extraCode) { 'bar = (+1)' }

  describe 'should pass on ok request' do
    let(:request) { qreq(okCode, okQuery) }
    it { expect(result).to eq ['6', :passed] }
  end
  describe 'should have result on ok request with query dependent on extra' do
    let(:request) { qreq(okCodeOnExtra, okQuery, extraCode) }
    it { expect(result).to eq ['4', :passed] }
  end
  describe 'should pass avoiding show function error' do
    let(:request) { qreq(okCode, okShowFunction) }
    it { expect(result).to eq ['<function>', :passed] }
  end
end

