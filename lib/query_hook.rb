class HaskellQueryHook < HaskellFileHook
  def compile_file_content(req)
    <<EOF
{-# OPTIONS_GHC -fdefer-type-errors #-}
import Text.Show.Functions
import Data.List
#{req.content}
#{req.extra}
EOF
  end

  def command_line(filename)
    ['bash', '-c', "ghci #{filename} <<< $0", request.query]
  end

  def post_process_file(_file, result, status)
    result = result.split("\n")[3..-2].join("\n")
    [result, status]
  end
end
