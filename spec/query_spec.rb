require_relative './spec_helper'

describe HaskellQueryHook do
  let(:hook) { HaskellQueryHook.new }
  let(:file) { hook.compile(request) }
  let(:result) { hook.run!(file) }

  let(:okQuery) { 'foo 3' }
  let(:okShowFunction) { 'even' }

  let(:okCodeOnExtra) { 'foo = bar' }
  let(:okCode) { 'foo = (*2)' }

  let(:extraCode) { 'bar = (+1)' }

  describe 'should pass on ok request' do
    let(:request) { qreq(okCode, okQuery) }
      it { expect(result).to eq ["6", :passed] }
  end

  describe 'should pass on a query that uses functions from Data.List' do
    let(:request) { qreq(okCode, "nub [1, 1, 2]") }
    it { expect(result).to eq ["[1,2]", :passed] }
  end

  describe 'should have result on ok request with query dependent on extra' do
    let(:request) { qreq(okCodeOnExtra, okQuery, extraCode) }
    it { expect(result).to eq ["4", :passed] }
  end
  describe 'should pass avoiding show function error' do
    let(:request) { qreq(okCode, okShowFunction) }
    it { expect(result).to eq ["<function>", :passed] }
  end

  describe 'should allow consulting a type' do
    let(:request) { qreq('', ':t length') }
    it { expect(result).to eq ["length :: Foldable t => t a -> Int", :passed] }
  end
end

