class TestHook < HaskellFileHook
  structured true

  def compile_file_content(req)
    <<EOF
{-# OPTIONS_GHC -fdefer-type-errors #-}
import Test.Hspec
import Test.Hspec.Formatters.Structured
import Test.Hspec.Runner (hspecWith, defaultConfig, Config (configFormatter))
import Test.QuickCheck
import qualified Control.Exception as Exception
#{req.content}
#{req.extra}
main :: IO ()
main = hspecWith defaultConfig {configFormatter = Just structured} $ do
 #{req.test}
EOF
  end
end
