describe TestHook do
  let(:hook) { TestHook.new(nil) }

  let(:sample_content) { 'x = True' }
  let(:sample_test) {
    <<HASKELL
describe "x" $ do
  it "should be True" $ do
    x `shouldBe` True"
HASKELL
  }
  let(:expected_compilation) {
    <<HASKELL
{-# OPTIONS_GHC -fdefer-type-errors #-}
import Test.Hspec
import Test.Hspec.Formatters.Structured
import Test.Hspec.Runner (hspecWith, defaultConfig, Config (configFormatter))
import Test.QuickCheck
import qualified Control.Exception as Exception
x = Truen
main :: IO ()
main = hspecWith defaultConfig {configFormatter = Just structured} $ do
describe "x" $ do
  it "should be True" $ do
    x `shouldBe` True"
HASKELL
  }

  it { expect(hook.compile(treq(sample_content, sample_test, '')).to eq expected_compilation) }
end

