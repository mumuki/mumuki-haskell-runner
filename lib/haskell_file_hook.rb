class HaskellFileHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.hs'
  end

  def command_line(filename)
    "#{runhaskell_command} #{filename}"
  end

end