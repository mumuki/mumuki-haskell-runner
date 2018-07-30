class HaskellFileHook < Mumukit::Templates::FileHook
  isolated true

  def cleanup_raw_result(result)
    super result.with_unescaped_unicode_esque_sequences
  end

  def tempfile_extension
    '.hs'
  end

  def command_line(filename)
    "runhaskell #{filename}"
  end

end