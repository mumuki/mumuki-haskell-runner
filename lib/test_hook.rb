class HaskellTestHook < HaskellFileHook
  structured true

  def to_structured_result(result)
    result = result.split('@@@RESULTS-START@@@').last
    super(result).compact
  end

  def has_files?(_req)
    true
  end

  def compile_file_content(req)
    {
      'Test.hs' => compile_test_file(req),
      'Code.hs' => compile_code_file(req)
    }
  end

  def compile_test_file(req)
    <<~HASKELL
      {-# OPTIONS_GHC -fdefer-type-errors #-}
      import Test.Hspec
      import Test.Hspec.Runner (hspecWith, defaultConfig, Config (configFormatter))
      import Test.QuickCheck
      import Test.Hspec.Formatters
      import Code
      
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
      
      main :: IO ()
      main = hspecWith defaultConfig {configFormatter = Just structured} $ do
      #{req.test.lines.map {|it| '    ' + it}.join}
    HASKELL
  end

  def compile_code_file(req)
    <<~HASKELL
      {-# OPTIONS_GHC -fdefer-type-errors #-}
      module Code where
      
      #{req.content}
      #{req.extra}
    HASKELL
  end

  def command_line(filename)
    "runhaskell #{filename}"
  end
end
