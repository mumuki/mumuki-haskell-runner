require_relative './spec_helper'

describe HaskellTestHook do
  let(:hook) { HaskellTestHook.new(nil) }
  let(:compilation) { hook.compile_file_content(treq(sample_content, sample_test, '')) }

  let(:sample_content) { 'x = True' }
  let(:sample_test) {
    <<~HASKELL
      describe "x" $ do
        it "should be True" $ do
          x `shouldBe` True
      describe y" $ do
        it "should be False" $ do
          x `shouldBe` False
    HASKELL
  }
  let(:expected_compilation_test_imports) do
    <<~HASKELL
      {-# OPTIONS_GHC -fdefer-type-errors #-}
      import Test.Hspec
      import Test.Hspec.Runner (hspecWith, defaultConfig, Config (configFormatter))
      import Test.QuickCheck
      import Test.Hspec.Formatters
      import Code
      
      import qualified Control.Exception as Exception
      
      import Data.List
    HASKELL
  end

  let(:expected_compilation_test_body) do
    <<~HASKELL
      main :: IO ()
      main = hspecWith defaultConfig {configFormatter = Just structured} $ do
          describe "x" $ do
            it "should be True" $ do
              x `shouldBe` True
          describe y" $ do
            it "should be False" $ do
              x `shouldBe` False
    HASKELL
  end
  let(:expected_compilation_code) do
    <<~HASKELL
      {-# OPTIONS_GHC -fdefer-type-errors #-}
      module Code where

      x = True
    HASKELL
  end

  it { expect(compilation['Test.hs']).to include expected_compilation_test_imports }
  it { expect(compilation['Test.hs']).to include expected_compilation_test_body }
  it { expect(compilation['Code.hs']).to include expected_compilation_code }
end

