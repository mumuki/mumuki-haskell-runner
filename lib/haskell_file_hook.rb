class HaskellFileHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.hs'
  end

  def command_line(filename)
    "runhaskell #{filename}"
  end

end