require_relative './spec_helper'

describe HaskellTestHook do
  let(:hook) { HaskellTestHook.new }

  describe '#run!' do
    let(:file) { hook.compile(treq(content, test, extra)) }
    let(:raw_results) { hook.run!(file) }
    let(:results) { raw_results[0] }

    let(:extra) { '' }
    let(:content) { '' }
    let(:test) { '' }

    context 'on simple passed file' do
      let(:content) { 'x = True' }
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should be True" $ do
      x `shouldBe` True
HASKELL
      end

      it { expect(results).to eq([['x should be True', 'passed', '']]) }
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
describe "x" $ do
  it "should be True" $ do
      x `shouldBe` True
HASKELL
      end
      it { expect(results).to eq([['x should be True', 'passed', '']]) }
    end

    context 'when test is not ok with type errors' do
      let(:content) do
        <<HASKELL
foo x = x + True
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should be True" $ do
      (foo 2) `shouldBe` True
HASKELL
      end
      it { expect(results[0][0..1]).to eq(['x should be True', 'failed']) }
      it { expect(results[0][2]).to include '(deferred type error)' }
    end


    context 'when test is ok with escaped strings' do
      let(:content) do
        <<HASKELL
x = "hello"
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should be \\"hello\\"" $ do
      x `shouldBe` "hello"
HASKELL
      end
      it { expect(results).to eq([['x should be "hello"', 'passed', '']]) }
    end


    context 'when test has expected exceptions and is ok' do
      let(:content) do
        <<HASKELL
x = True
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should fail" $ do
      Exception.evaluate (length x) `shouldThrow` anyErrorCall
HASKELL
      end
      it { expect(results).to eq([['x should fail', 'passed', '']]) }
    end


    context 'when test has expected exceptions and is not ok' do
      let(:content) do
        <<HASKELL
x = [2, 3]
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should fail" $ do
      Exception.evaluate (length x) `shouldThrow` anyErrorCall
HASKELL
      end
      it { expect(results).to eq([['x should fail', 'failed', 'did not get expected exception: ErrorCall']]) }
    end

    context 'when test is not ok' do
      let(:content) do
        <<HASKELL
x = False
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should be True" $ do
      x `shouldBe` True
HASKELL
      end
      it { expect(results).to eq([['x should be True', 'failed', "expected: True\n but got: False"]]) }
    end

    context 'when test does not compile' do
      let(:content) do
        <<HASKELL
y = False
HASKELL
      end
      let(:test) do
        <<HASKELL
describe "x" $ do
  it "should be True" $ do
      x `shouldBe` True
HASKELL
      end
      it { expect(raw_results[0]).to include('Not in scope: ‘x’') }
      it { expect(raw_results[1]).to eq :errored }
    end
  end
end


