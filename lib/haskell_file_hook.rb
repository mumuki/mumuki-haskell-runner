class HaskellFileHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.hs'
  end

  def run_test_command(filename)
    "#{runhaskell_command} #{filename}"
  end

end