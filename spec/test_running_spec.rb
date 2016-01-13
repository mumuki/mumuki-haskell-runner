require_relative './spec_helper'

describe TestHook do
  let(:hook) { TestHook.new('runhaskell_command' => 'runhaskell') }

  describe '#run!' do
    let(:file) { hook.compile(treq(content, test, extra)) }
    let(:results) { hook.run!(file)[0] }

    let(:extra) { '' }
    let(:content) { '' }
    let(:test) { '' }

    context 'on simple passed file' do
      let(:content) { 'x = True' }
      let(:test) do
        <<HASKELL
describe "x\" $ do
  it \"should be True\" $ do
      x `shouldBe` True"
HASKELL
      end

      it { expect(results).to eq([['_true is true', :passed, '']]) }
    end

    context 'on simple passed with warnings' do
      let(:content) do
        <<HASKELL
x = True
foo x = True
foo _ = False
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x\" $ do
  it \"should be True\" $ do
      x `shouldBe` True"
HASKELL
      end
      it { expect(results).to eq([['_true is true', :passed, '']]) }
    end

    context 'on simple passed with warnings' do
      let(:content) do
        <<HASKELL
x = True
foo x = True
foo _ = False
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x\" $ do
  it \"should be True\" $ do
      x `shouldBe` True"
HASKELL
      end
      it { expect(results).to eq([['_true is true', :passed, '']]) }
    end
  end
end
