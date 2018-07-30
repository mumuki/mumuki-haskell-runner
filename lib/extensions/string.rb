class String
  # Example: "coffee: \9749" for "coffee: ☕"
  def with_unescaped_unicode_esque_sequences
    self.force_encoding('UTF-8').gsub(/\\(\d+)/) { |m|
      [$1.to_i.to_s(16).rjust(4, '0')].pack("H*").unpack("n*").pack("U*")
    }
  end
end