class HaskellQueryHook < HaskellFileHook
  def compile_file_content(req)
    <<EOF
import Text.Show.Functions
#{req.content}
#{req.extra}
main :: IO ()
main = putStrLn.show $ #{req.query}
EOF
  end
end
