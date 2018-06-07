class HaskellExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Haskell'
  end
  
  def default_smell_exceptions
    LOGIC_SMELLS + %w(DoesTypeTest)
  end
end
