class TestHook < HaskellFileHook
  structured true

  def to_structured_result(result)
    result = result.split('@@@RESULTS-START@@@').last
    super(result).compact
  end

  def compile_file_content(req)
    <<-EOF
{-# OPTIONS_GHC -fdefer-type-errors #-}
import Test.Hspec
import Test.Hspec.Runner (hspecWith, defaultConfig, Config (configFormatter))
import Test.QuickCheck
import Test.Hspec.Formatters

import qualified Control.Exception as Exception

import Data.List

structured :: Formatter
structured = silent {
  exampleSucceeded = \\p ->
    writeTerm [formatPath p, "passed", ""],
  exampleFailed    = \\p result -> case result of
      (Right e) -> writeTerm [formatPath p, "failed", e]
      (Left e)  -> writeTerm [formatPath p, "failed", show e],
  headerFormatter  = write $ "@@@RESULTS-START@@@[",
  footerFormatter  = write $ "null]"
}
  where formatPath (ps, p) = intercalate " " $ (ps ++ [p])
        writeTerm = write.(++",").show

#{req.content}
#{req.extra}
main :: IO ()
main = hspecWith defaultConfig {configFormatter = Just structured} $ do
 #{req.test}
EOF
  end
end
