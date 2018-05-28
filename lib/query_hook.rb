class HaskellQueryHook < HaskellFileHook
  def compile_file_content(req)
    <<EOF
{-# OPTIONS_GHC -fdefer-type-errors #-}
import Text.Show.Functions
import Data.List
#{req.content}
#{req.extra}
main :: IO ()
main = putStrLn.show $ #{req.query}
EOF
  end
end
